import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherAnalysisCard extends StatelessWidget {
  final WeatherModel weather;
  final List<DailyForecast> forecast;

  const WeatherAnalysisCard({
    super.key,
    required this.weather,
    required this.forecast,
  });

  String _getWeatherAnalysis() {
    final temp = weather.temperature;
    final humidity = weather.humidity;
    final windSpeed = weather.windSpeed;
    final description = weather.description.toLowerCase();

    if (temp > 30) {
      return 'Cuaca sangat panas hari ini. Pastikan untuk minum air yang cukup dan hindari aktivitas di luar ruangan pada siang hari.';
    } else if (temp > 25) {
      return 'Cuaca hangat dan nyaman. Cocok untuk aktivitas luar ruangan dengan perlindungan dari sinar matahari.';
    } else if (temp > 20) {
      return 'Suhu sedang dan nyaman. Waktu yang ideal untuk berbagai aktivitas outdoor.';
    } else if (temp > 15) {
      return 'Cuaca sejuk. Gunakan pakaian yang cukup hangat untuk aktivitas luar ruangan.';
    } else {
      return 'Cuaca dingin. Pastikan menggunakan pakaian hangat dan hindari paparan udara dingin terlalu lama.';
    }
  }

  String _getHumidityAnalysis() {
    final humidity = weather.humidity;

    if (humidity > 80) {
      return 'Kelembaban tinggi - udara terasa lembab dan tidak nyaman.';
    } else if (humidity > 60) {
      return 'Kelembaban sedang - kondisi udara normal.';
    } else if (humidity > 40) {
      return 'Kelembaban rendah - udara terasa kering.';
    } else {
      return 'Kelembaban sangat rendah - gunakan pelembap udara jika diperlukan.';
    }
  }

  String _getWindAnalysis() {
    final windSpeed = weather.windSpeed;

    if (windSpeed > 20) {
      return 'Angin kencang - hati-hati dengan benda yang bisa terbang.';
    } else if (windSpeed > 10) {
      return 'Angin sedang - nyaman untuk aktivitas luar ruangan.';
    } else if (windSpeed > 5) {
      return 'Angin lembut - kondisi ideal untuk berbagai aktivitas.';
    } else {
      return 'Angin tenang - udara stabil dan nyaman.';
    }
  }

  String _getWeeklyTrend() {
    if (forecast.isEmpty) return 'Data prakiraan tidak tersedia.';

    final avgTemp = forecast
            .map((f) => (f.maxTemp + f.minTemp) / 2)
            .reduce((a, b) => a + b) /
        forecast.length;
    final tempRange =
        forecast.map((f) => f.maxTemp - f.minTemp).reduce((a, b) => a + b) /
            forecast.length;

    if (avgTemp > 28) {
      return 'Minggu ini diprediksi hangat dengan suhu rata-rata tinggi.';
    } else if (avgTemp > 22) {
      return 'Minggu ini diprediksi nyaman dengan suhu sedang.';
    } else {
      return 'Minggu ini diprediksi sejuk dengan suhu rendah.';
    }
  }

  Color _getAnalysisColor() {
    // Warna konsisten untuk analisis - tidak mengikuti perubahan cuaca
    return const Color(0xFF1A252F); // Warna biru gelap yang lebih kontras
  }

  Color _getSecondaryColor() {
    // Warna sekunder yang konsisten
    return const Color(0xFF2980B9); // Warna biru medium yang lebih kontras
  }

  Color _getAccentColor() {
    // Warna aksen yang konsisten
    return const Color(0xFF5D6D7E); // Warna abu-abu yang lebih kontras
  }

  Color _getTextColor() {
    // Warna teks yang kontras dengan background putih tulang
    return const Color(0xFF2C3E50); // Warna biru gelap untuk teks
  }

  Color _getSubTextColor() {
    // Warna teks sekunder yang kontras
    return const Color(0xFF34495E); // Warna biru abu-abu untuk teks sekunder
  }

  Color _getBackgroundColor() {
    // Warna putih tulang (off-white) yang lembut
    return const Color(0xFFF8F9FA); // Warna putih tulang yang nyaman di mata
  }

  Color _getCardBackgroundColor() {
    // Warna putih tulang yang lebih terang untuk card
    return const Color(0xFFFAFBFC); // Warna putih tulang terang
  }

  Color _getIconColor() {
    // Warna ikon yang kontras dengan background putih tulang
    return const Color(0xFF1E3A8A); // Warna biru gelap untuk ikon
  }

  Color _getIconBackgroundColor() {
    // Warna background ikon yang kontras
    return const Color(
        0xFFE5E7EB); // Warna abu-abu terang untuk background ikon
  }

  @override
  Widget build(BuildContext context) {
    final analysisColor = _getAnalysisColor();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getCardBackgroundColor(),
            _getBackgroundColor(),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getAnalysisColor().withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _getAnalysisColor().withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Analisis
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getIconBackgroundColor(),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getIconColor().withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.analytics,
                  color: _getIconColor(),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analisis Cuaca',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getTextColor(),
                    ),
                  ),
                  Text(
                    'Berdasarkan data saat ini',
                    style: TextStyle(
                      fontSize: 12,
                      color: _getSubTextColor(),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Analisis Utama
          _buildAnalysisSection(
            title: 'Kondisi Umum',
            content: _getWeatherAnalysis(),
            icon: Icons.wb_sunny,
            color: _getIconColor(),
          ),

          const SizedBox(height: 16),

          // Analisis Detail
          Row(
            children: [
              Expanded(
                child: _buildAnalysisSection(
                  title: 'Kelembaban',
                  content: _getHumidityAnalysis(),
                  icon: Icons.water_drop,
                  color: _getIconColor(),
                  isCompact: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnalysisSection(
                  title: 'Angin',
                  content: _getWindAnalysis(),
                  icon: Icons.air,
                  color: _getIconColor(),
                  isCompact: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Prakiraan Mingguan
          _buildAnalysisSection(
            title: 'Prakiraan Mingguan',
            content: _getWeeklyTrend(),
            icon: Icons.calendar_today,
            color: _getIconColor(),
          ),

          const SizedBox(height: 16),

          // Tips Cuaca
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getIconColor().withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getIconBackgroundColor(),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getIconColor().withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.lightbulb_outline,
                    color: _getIconColor(),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getWeatherTips(),
                    style: TextStyle(
                      fontSize: 14,
                      color: _getTextColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
    bool isCompact = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isCompact ? 4 : 6),
                decoration: BoxDecoration(
                  color: _getIconBackgroundColor(),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: color.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: isCompact ? 14 : 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: isCompact ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  color: _getTextColor(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: isCompact ? 11 : 13,
              color: _getSubTextColor(),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _getWeatherTips() {
    final temp = weather.temperature;
    final description = weather.description.toLowerCase();

    if (description.contains('hujan')) {
      return 'Bawa payung atau jas hujan, hindari aktivitas outdoor, dan perhatikan kondisi jalan yang licin.';
    } else if (description.contains('mendung') ||
        description.contains('berawan')) {
      return 'Kondisi nyaman untuk aktivitas outdoor, namun tetap waspada dengan kemungkinan hujan.';
    } else if (description.contains('cerah') ||
        description.contains('matahari')) {
      return 'Gunakan tabir surya, topi, dan pakaian yang menutupi kulit untuk melindungi dari sinar UV.';
    } else if (temp > 30) {
      return 'Minum air yang cukup, hindari aktivitas di luar ruangan pada siang hari, dan gunakan pakaian yang menyerap keringat.';
    } else if (temp < 15) {
      return 'Gunakan pakaian hangat, hindari paparan udara dingin terlalu lama, dan pastikan rumah tetap hangat.';
    } else {
      return 'Kondisi cuaca ideal untuk berbagai aktivitas. Nikmati hari Anda dengan aman dan nyaman.';
    }
  }
}
