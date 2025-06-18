class WeatherModel {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final DateTime date;
  final String location;

  WeatherModel({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.date,
    required this.location,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String location) {
    return WeatherModel(
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      location: location,
    );
  }

  String get temperatureText => '${temperature.round()}°';
  String get feelsLikeText => '${feelsLike.round()}°';
  String get humidityText => '$humidity%';
  String get windSpeedText => '${windSpeed.round()} km/h';
  String get descriptionText => description.capitalize();
}

class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String description;
  final String icon;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.description,
    required this.icon,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      maxTemp: json['temp']['max'].toDouble(),
      minTemp: json['temp']['min'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }

  String get dayName {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final forecastDate = DateTime(date.year, date.month, date.day);

    if (forecastDate == today) {
      return 'Hari Ini';
    } else if (forecastDate == today.add(const Duration(days: 1))) {
      return 'Besok';
    } else {
      final days = [
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
        'Minggu',
      ];
      return days[date.weekday - 1];
    }
  }

  String get dayShort {
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[date.weekday - 1];
  }

  String get maxTempText => '${maxTemp.round()}°';
  String get minTempText => '${minTemp.round()}°';
  String get descriptionText => description.capitalize();
}

class Location {
  final String name;
  final double lat;
  final double lon;
  final String country;
  final String? state;

  Location({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    this.state,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
      country: json['country'],
      state: json['state'],
    );
  }

  String get displayName {
    if (name.isEmpty || name.toLowerCase() == 'unknown' || name == '-') {
      return 'Lokasi tidak tersedia';
    }
    if (state != null &&
        state!.isNotEmpty &&
        state!.toLowerCase() != 'unknown') {
      return '$name, $state';
    }
    if (country.isEmpty || country.toLowerCase() == 'unknown') {
      return name;
    }
    return '$name, $country';
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
