import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Ganti dengan API key Anda dari https://openweathermap.org/api
  String get _apiKey => '7ddd5ad51734ffd89cb3ce26116b5c4b';

  Future<WeatherModel> getCurrentWeather(double lat, double lon) async {
    try {
      final url = Uri.parse(
          '$_baseUrl/weather?lat=$lat&lon=$lon&units=metric&appid=$_apiKey&lang=id');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data, data['name'] ?? 'Unknown');
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      // Return mock data as fallback
      return getMockWeather();
    }
  }

  Future<List<DailyForecast>> getDailyForecast(double lat, double lon) async {
    try {
      final url = Uri.parse(
          '$_baseUrl/forecast?lat=$lat&lon=$lon&units=metric&appid=$_apiKey&lang=id');

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
          }
        }

        return dailyData.values
            .take(7)
            .map((json) => DailyForecast.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching forecast data: $e');
      // Return mock data as fallback
      return getMockForecast();
    }
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
