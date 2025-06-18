import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class ForecastCard extends StatefulWidget {
  final DailyForecast forecast;
  final bool isSelected;

  const ForecastCard({
    super.key,
    required this.forecast,
    this.isSelected = false,
  });

  @override
  State<ForecastCard> createState() => _ForecastCardState();
}

class _ForecastCardState extends State<ForecastCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Color _getWeatherColor() {
    final description = widget.forecast.description.toLowerCase();

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
      final hour = widget.forecast.date.hour;
      if (hour >= 6 && hour <= 18) {
        return const Color(0xFFFF9500); // Orange siang
      } else {
        return const Color(0xFF007AFF); // Biru malam
      }
    }
  }

  Color _getBackgroundColor() {
    final weatherColor = _getWeatherColor();
    if (widget.isSelected) {
      return weatherColor.withOpacity(0.15);
    } else {
      return Colors.white.withOpacity(0.95);
    }
  }

  Color _getBorderColor() {
    final weatherColor = _getWeatherColor();
    if (widget.isSelected) {
      return weatherColor.withOpacity(0.4);
    } else {
      return Colors.grey.withOpacity(0.1);
    }
  }

  Color _getShadowColor() {
    final weatherColor = _getWeatherColor();
    if (_isHovered) {
      return weatherColor.withOpacity(0.25);
    } else {
      return Colors.black.withOpacity(0.06);
    }
  }

  IconData _getWeatherIcon() {
    final description = widget.forecast.description.toLowerCase();
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

  Color _getSelectedBorderColor() =>
      const Color(0xFF90CAF9); // Biru muda untuk border selected

  @override
  Widget build(BuildContext context) {
    final weatherIcon = _getWeatherIcon();
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 100,
              height: 140,
              margin: const EdgeInsets.symmetric(horizontal: 6),
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
                  color: widget.isSelected
                      ? _getSelectedBorderColor()
                      : _getIconBorderColor().withOpacity(0.18),
                  width: widget.isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getIconBorderColor()
                        .withOpacity(_isHovered ? 0.18 : 0.10),
                    blurRadius: _isHovered ? 12 : 8,
                    offset: const Offset(0, 4),
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Day indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? _getSelectedBorderColor().withOpacity(0.15)
                          : _getIconBorderColor().withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.forecast.dayShort,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getMainTextColor(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Weather icon with animated background
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _getIconBgColor(),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getIconBorderColor().withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      weatherIcon,
                      color: _getIconColor(),
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Temperature display
                  Column(
                    children: [
                      Text(
                        widget.forecast.maxTempText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _getMainTextColor(),
                        ),
                      ),
                      Text(
                        widget.forecast.minTempText,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getSubTextColor().withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Description
                  Text(
                    widget.forecast.descriptionText,
                    style: TextStyle(
                      fontSize: 11,
                      color: _getSubTextColor().withOpacity(0.85),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
