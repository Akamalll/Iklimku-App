import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class ForecastDetailCard extends StatelessWidget {
  final DailyForecast forecast;

  const ForecastDetailCard({
    super.key,
    required this.forecast,
  });

  // Warna-warna baru untuk kontras dan kemudahan baca
  Color _getMainTextColor() => const Color(0xFF1A252F); // Biru gelap
  Color _getSubTextColor() => const Color(0xFF34495E); // Abu-abu gelap
  Color _getIconColor() => const Color(0xFF1E3A8A); // Biru gelap untuk ikon
  Color _getIconBgColor() => Colors.white; // Putih untuk background ikon
  Color _getIconBorderColor() => const Color(0xFFE3F0FF); // Biru langit muda
  Color _getCardBgStart() => const Color(0xFFE3F0FF); // Biru langit terang
  Color _getCardBgEnd() => const Color(0xFFF8F9FA); // Putih tulang

  Color _getWeatherColor() {
    final description = forecast.description.toLowerCase();

    // Warna berdasarkan kondisi cuaca
    if (description.contains('hujan') || description.contains('rain')) {
      return const Color(0xFF5B9BD5); // Biru hujan yang lebih soft
    } else if (description.contains('mendung') ||
        description.contains('berawan') ||
        description.contains('cloud') ||
        description.contains('overcast')) {
      return const Color(0xFF8E8E93); // Abu-abu mendung
    } else if (description.contains('cerah') ||
        description.contains('matahari') ||
        description.contains('clear') ||
        description.contains('sunny')) {
      return const Color(0xFFFF9500); // Orange cerah yang lebih vibrant
    } else if (description.contains('angin') || description.contains('wind')) {
      return const Color(0xFF34C759); // Hijau angin yang segar
    } else if (description.contains('salju') || description.contains('snow')) {
      return const Color(0xFFAFE1FF); // Biru muda salju
    } else if (description.contains('kabut') ||
        description.contains('fog') ||
        description.contains('mist')) {
      return const Color(0xFFC7C7CC); // Abu-abu kabut
    } else {
      // Default berdasarkan waktu
      final hour = forecast.date.hour;
      if (hour >= 6 && hour <= 18) {
        return const Color(0xFFFF9500); // Orange siang
      } else {
        return const Color(0xFF007AFF); // Biru malam
      }
    }
  }

  Color _getBackgroundColor() {
    final weatherColor = _getWeatherColor();
    return weatherColor.withOpacity(0.12);
  }

  Color _getBorderColor() {
    final weatherColor = _getWeatherColor();
    return weatherColor.withOpacity(0.25);
  }

  Color _getShadowColor() {
    final weatherColor = _getWeatherColor();
    return weatherColor.withOpacity(0.12);
  }

  IconData _getWeatherIcon() {
    final description = forecast.description.toLowerCase();
    if (description.contains('hujan')) {
      return Icons.water_drop;
    } else if (description.contains('mendung') ||
        description.contains('berawan')) {
      return Icons.cloud;
    } else if (description.contains('cerah') ||
        description.contains('matahari')) {
      return Icons.wb_sunny;
    } else if (description.contains('angin')) {
      return Icons.air;
    } else {
      return Icons.wb_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherIcon = _getWeatherIcon();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getCardBgStart(),
            _getCardBgEnd(),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getIconBorderColor().withOpacity(0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _getIconBorderColor().withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header dengan hari dan tanggal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    forecast.dayName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getMainTextColor(),
                    ),
                  ),
                  Text(
                    '${forecast.date.day}/${forecast.date.month}/${forecast.date.year}',
                    style: TextStyle(
                      fontSize: 14,
                      color: _getSubTextColor().withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getIconBgColor(),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: _getIconBorderColor().withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Icon(
                  weatherIcon,
                  color: _getIconColor(),
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Temperature section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Max temperature
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        forecast.maxTempText,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: _getMainTextColor(),
                        ),
                      ),
                      Text(
                        'max',
                        style: TextStyle(
                          fontSize: 12,
                          color: _getSubTextColor().withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Divider
              Container(
                height: 40,
                width: 1,
                color: _getIconBorderColor().withOpacity(0.2),
              ),
              // Min temperature
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        forecast.minTempText,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: _getMainTextColor(),
                        ),
                      ),
                      Text(
                        'min',
                        style: TextStyle(
                          fontSize: 12,
                          color: _getSubTextColor().withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Weather description
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getIconBorderColor().withOpacity(0.13),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              forecast.descriptionText,
              style: TextStyle(
                fontSize: 14,
                color: _getSubTextColor(),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          // Additional info row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(
                icon: Icons.thermostat,
                label: 'Suhu Rata-rata',
                value:
                    '${((forecast.maxTemp + forecast.minTemp) / 2).round()}°',
                color: _getIconColor(),
              ),
              _buildInfoItem(
                icon: Icons.calendar_today,
                label: 'Hari',
                value: forecast.dayName,
                color: _getIconColor(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: _getIconBgColor(),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _getIconBorderColor().withOpacity(0.4),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: _getSubTextColor().withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _getMainTextColor(),
          ),
        ),
      ],
    );
  }
}
