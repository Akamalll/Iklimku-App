import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherCard extends StatefulWidget {
  final WeatherModel weather;

  const WeatherCard({
    super.key,
    required this.weather,
  });

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getWeatherColor() {
    final description = widget.weather.description.toLowerCase();

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
      final hour = widget.weather.date.hour;
      if (hour >= 6 && hour <= 18) {
        return const Color(0xFFFF9500); // Orange siang
      } else {
        return const Color(0xFF007AFF); // Biru malam
      }
    }
  }

  Color _getBackgroundColor() {
    final weatherColor = _getWeatherColor();
    return weatherColor.withOpacity(0.08);
  }

  Color _getBorderColor() {
    final weatherColor = _getWeatherColor();
    return weatherColor.withOpacity(0.2);
  }

  Color _getShadowColor() {
    final weatherColor = _getWeatherColor();
    return weatherColor.withOpacity(0.15);
  }

  IconData _getWeatherIcon() {
    final description = widget.weather.description.toLowerCase();
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

  // Warna-warna baru untuk kontras dan kemudahan baca
  Color _getMainTextColor() => const Color(0xFF1A252F); // Biru gelap
  Color _getSubTextColor() => const Color(0xFF34495E); // Abu-abu gelap
  Color _getIconColor() => const Color(0xFF1E3A8A); // Biru gelap untuk ikon
  Color _getIconBgColor() => Colors.white; // Putih untuk background ikon
  Color _getIconBorderColor() => const Color(0xFFE3F0FF); // Biru langit muda
  Color _getCardBgStart() => const Color(0xFFE3F0FF); // Biru langit terang
  Color _getCardBgEnd() => const Color(0xFFF8F9FA); // Putih tulang

  @override
  Widget build(BuildContext context) {
    final weatherIcon = _getWeatherIcon();
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getCardBgStart(),
                _getCardBgEnd(),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _getIconBorderColor().withOpacity(0.18),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _getIconBorderColor().withOpacity(0.10),
                blurRadius: 15,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // Header dengan lokasi dan waktu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hari Ini',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _getMainTextColor(),
                        ),
                      ),
                      Text(
                        '${widget.weather.date.day}/${widget.weather.date.month}/${widget.weather.date.year}',
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
                      borderRadius: BorderRadius.circular(14),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.weather.temperatureText,
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: _getMainTextColor(),
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Weather details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherDetail(
                    icon: Icons.thermostat,
                    label: 'Suhu Rata-rata',
                    value: widget.weather.temperatureText,
                    color: _getIconColor(),
                  ),
                  _buildWeatherDetail(
                    icon: Icons.calendar_today,
                    label: 'Hari',
                    value: 'Hari Ini',
                    color: _getIconColor(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getIconBgColor(),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getIconBorderColor().withOpacity(0.4),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _getMainTextColor(),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _getSubTextColor().withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
