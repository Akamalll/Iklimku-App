import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Ganti dengan API key Anda dari https://openweathermap.org/api
  String get _apiKey => '7ddd5ad51734ffd89cb3ce26116b5c4b';

  // Cache untuk menyimpan data terakhir
  WeatherModel? _cachedWeather;
  List<DailyForecast>? _cachedForecast;
  DateTime? _lastFetchTime;
  static const Duration _cacheDuration = Duration(minutes: 10);

  // Check if cache is still valid
  bool get _isCacheValid {
    if (_lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < _cacheDuration;
  }

  Future<WeatherModel> getCurrentWeather(double lat, double lon,
      {bool forceRefresh = false}) async {
    // Return cached data if still valid and not forcing refresh
    if (!forceRefresh && _isCacheValid && _cachedWeather != null) {
      print('Returning cached weather data');
      return _cachedWeather!;
    }

    try {
      final url = Uri.parse(
          '$_baseUrl/weather?lat=$lat&lon=$lon&units=metric&appid=$_apiKey&lang=id');

      print('Fetching weather data from API...');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weather = WeatherModel.fromJson(data, data['name'] ?? 'Unknown');

        // Update cache
        _cachedWeather = weather;
        _lastFetchTime = DateTime.now();

        print('Weather data updated successfully: ${weather.temperature}°C');
        return weather;
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching weather data: $e');

      // Return cached data if available, otherwise return mock data
      if (_cachedWeather != null) {
        print('Returning cached weather data due to error');
        return _cachedWeather!;
      }

      print('No cached data available, returning mock data');
      return getMockWeather();
    }
  }

  Future<List<DailyForecast>> getDailyForecast(double lat, double lon,
      {bool forceRefresh = false}) async {
    // Return cached data if still valid and not forcing refresh
    if (!forceRefresh && _isCacheValid && _cachedForecast != null) {
      print('Returning cached forecast data');
      return _cachedForecast!;
    }

    try {
      final url = Uri.parse(
          '$_baseUrl/forecast?lat=$lat&lon=$lon&units=metric&appid=$_apiKey&lang=id');

      print('Fetching forecast data from API...');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> listData = data['list'];

        // Group by day and get daily forecast
        Map<String, dynamic> dailyData = {};
        for (var item in listData) {
          DateTime date =
              DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
          String dayKey = '${date.year}-${date.month}-${date.day}';

          if (!dailyData.containsKey(dayKey)) {
            dailyData[dayKey] = {
              'dt': item['dt'],
              'temp': {
                'max': item['main']['temp'],
                'min': item['main']['temp']
              },
              'weather': item['weather'],
              'count': 1, // Track number of readings per day
            };
          } else {
            // Update max/min temperatures
            double currentMax = dailyData[dayKey]['temp']['max'];
            double currentMin = dailyData[dayKey]['temp']['min'];
            double newTemp = item['main']['temp'];

            dailyData[dayKey]['temp']['max'] =
                newTemp > currentMax ? newTemp : currentMax;
            dailyData[dayKey]['temp']['min'] =
                newTemp < currentMin ? newTemp : currentMin;
            dailyData[dayKey]['count']++;
          }
        }

        // Convert to list and sort by date
        final sortedData = dailyData.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

        final forecast = sortedData
            .take(7)
            .map((entry) => DailyForecast.fromJson(entry.value))
            .toList();

        // Update cache
        _cachedForecast = forecast;
        _lastFetchTime = DateTime.now();

        print('Forecast data updated successfully: ${forecast.length} days');
        print(
            'Today forecast: ${forecast.first.maxTemp}°C / ${forecast.first.minTemp}°C');
        return forecast;
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching forecast data: $e');

      // Return cached data if available, otherwise return mock data
      if (_cachedForecast != null) {
        print('Returning cached forecast data due to error');
        return _cachedForecast!;
      }

      print('No cached data available, returning mock data');
      return getMockForecast();
    }
  }

  // Method untuk mendapatkan data yang sinkron antara current dan forecast
  Future<Map<String, dynamic>> getSynchronizedWeatherData(
      double lat, double lon,
      {bool forceRefresh = false}) async {
    print('Fetching synchronized weather data...');

    try {
      // Fetch both current weather and forecast simultaneously
      final currentWeatherFuture =
          getCurrentWeather(lat, lon, forceRefresh: forceRefresh);
      final forecastFuture =
          getDailyForecast(lat, lon, forceRefresh: forceRefresh);

      final results = await Future.wait([currentWeatherFuture, forecastFuture]);
      final currentWeather = results[0] as WeatherModel;
      final forecast = results[1] as List<DailyForecast>;

      // Ensure today's forecast matches current weather
      if (forecast.isNotEmpty) {
        final today = DateTime.now();
        final todayForecast = forecast.first;

        // Check if today's forecast date matches current date
        final isSameDay = todayForecast.date.year == today.year &&
            todayForecast.date.month == today.month &&
            todayForecast.date.day == today.day;

        if (isSameDay) {
          print('Current weather: ${currentWeather.temperature}°C');
          print(
              'Today forecast: ${todayForecast.maxTemp}°C / ${todayForecast.minTemp}°C');

          // If there's a significant difference, adjust the forecast
          final tempDiff =
              (currentWeather.temperature - todayForecast.maxTemp).abs();
          if (tempDiff > 2.0) {
            print('Temperature difference detected: $tempDiff°C');
            print('Adjusting today\'s forecast to match current weather');

            // Create adjusted forecast for today
            final adjustedTodayForecast = DailyForecast(
              date: todayForecast.date,
              maxTemp: currentWeather.temperature,
              minTemp: currentWeather.temperature - 3.0, // Estimate min temp
              description: currentWeather.description,
              icon: currentWeather.icon,
            );

            // Replace today's forecast
            forecast[0] = adjustedTodayForecast;
            _cachedForecast = forecast;
          }
        }
      }

      return {
        'current': currentWeather,
        'forecast': forecast,
      };
    } catch (e) {
      print('Error fetching synchronized weather data: $e');
      rethrow;
    }
  }

  // Method untuk refresh data secara paksa
  Future<void> refreshData(double lat, double lon) async {
    print('Forcing refresh of weather data...');
    await getCurrentWeather(lat, lon, forceRefresh: true);
    await getDailyForecast(lat, lon, forceRefresh: true);
  }

  // Method untuk clear cache
  void clearCache() {
    _cachedWeather = null;
    _cachedForecast = null;
    _lastFetchTime = null;
    print('Weather cache cleared');
  }

  // Method untuk check jika data perlu di-refresh
  bool get needsRefresh {
    if (_lastFetchTime == null) return true;
    return DateTime.now().difference(_lastFetchTime!) >= _cacheDuration;
  }

  Future<List<Location>> searchLocation(String query) async {
    try {
      final url = Uri.parse(
          'https://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$_apiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Location.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching location: $e');
      // Return empty list as fallback
      return [];
    }
  }

  // Mock data for testing
  WeatherModel getMockWeather() {
    return WeatherModel(
      temperature: 28.5,
      feelsLike: 30.2,
      humidity: 75,
      windSpeed: 12.5,
      description: 'cerah',
      icon: '01d',
      date: DateTime.now(),
      location: 'Jakarta, Indonesia',
    );
  }

  List<DailyForecast> getMockForecast() {
    return [
      DailyForecast(
        date: DateTime.now(),
        maxTemp: 32.0,
        minTemp: 24.0,
        description: 'cerah',
        icon: '01d',
      ),
      DailyForecast(
        date: DateTime.now().add(const Duration(days: 1)),
        maxTemp: 33.0,
        minTemp: 25.0,
        description: 'berawan',
        icon: '02d',
      ),
      DailyForecast(
        date: DateTime.now().add(const Duration(days: 2)),
        maxTemp: 31.0,
        minTemp: 23.0,
        description: 'hujan ringan',
        icon: '10d',
      ),
      DailyForecast(
        date: DateTime.now().add(const Duration(days: 3)),
        maxTemp: 30.0,
        minTemp: 22.0,
        description: 'berawan',
        icon: '03d',
      ),
      DailyForecast(
        date: DateTime.now().add(const Duration(days: 4)),
        maxTemp: 29.0,
        minTemp: 21.0,
        description: 'cerah',
        icon: '01d',
      ),
      DailyForecast(
        date: DateTime.now().add(const Duration(days: 5)),
        maxTemp: 31.0,
        minTemp: 23.0,
        description: 'hujan',
        icon: '09d',
      ),
      DailyForecast(
        date: DateTime.now().add(const Duration(days: 6)),
        maxTemp: 28.0,
        minTemp: 20.0,
        description: 'cerah',
        icon: '01d',
      ),
    ];
  }
}
