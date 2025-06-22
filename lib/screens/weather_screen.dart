import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/forecast_detail_card.dart';
import '../widgets/weather_analysis_card.dart';
import 'dart:async';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  WeatherModel? _currentWeather;
  List<DailyForecast> _forecast = [];
  String _locationName = '';
  bool _isLoading = false;
  String? _errorMessage;
  List<Location> _searchResults = [];
  bool _isSearching = false;
  int _selectedForecastIndex = 0;

  // Timer untuk auto refresh
  Timer? _autoRefreshTimer;
  static const Duration _autoRefreshInterval = Duration(minutes: 5);

  // Animation controllers untuk background
  late AnimationController _backgroundAnimationController;
  late Animation<double> _backgroundAnimation;

  // State untuk hover effect pada tombol refresh
  bool _isRefreshHovered = false;

  // Scroll controller dan state untuk header
  final ScrollController _scrollController = ScrollController();
  bool _isHeaderVisible = true;
  double _lastScrollPosition = 0;

  // Current position untuk refresh
  Map<String, double>? _currentPosition;

  @override
  void initState() {
    super.initState();

    // Setup background animation
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    // Setup scroll listener
    _scrollController.addListener(_onScroll);

    _loadWeatherData();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    _backgroundAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(_autoRefreshInterval, (timer) {
      if (_currentPosition != null && !_isLoading) {
        print('Auto refreshing weather data...');
        _refreshWeatherData();
      }
    });
  }

  void _stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
  }

  void _onScroll() {
    final currentScrollPosition = _scrollController.position.pixels;

    // Tentukan arah scroll dan visibility header
    if (currentScrollPosition > _lastScrollPosition && _isHeaderVisible) {
      // Scroll ke bawah - sembunyikan header
      setState(() {
        _isHeaderVisible = false;
      });
    } else if (currentScrollPosition < _lastScrollPosition &&
        !_isHeaderVisible) {
      // Scroll ke atas - tampilkan header
      setState(() {
        _isHeaderVisible = true;
      });
    }

    _lastScrollPosition = currentScrollPosition;
  }

  void _animateBackgroundChange() {
    _backgroundAnimationController.reset();
    _backgroundAnimationController.forward();
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get current location
      final position = await _locationService.getCurrentLocation();

      if (position != null) {
        _currentPosition = position;

        // Get location name
        _locationName = await _locationService.getLocationName(
          position['latitude']!,
          position['longitude']!,
        );

        // Get synchronized weather data (current + forecast)
        final weatherData = await _weatherService.getSynchronizedWeatherData(
          position['latitude']!,
          position['longitude']!,
        );

        setState(() {
          _currentWeather = weatherData['current'] as WeatherModel;
          _forecast = weatherData['forecast'] as List<DailyForecast>;
          _isLoading = false;
        });

        // Animate background change
        _animateBackgroundChange();

        print('Weather data loaded successfully');
        print('Current temperature: ${_currentWeather!.temperature}°C');
        print(
            'Today forecast: ${_forecast.first.maxTemp}°C / ${_forecast.first.minTemp}°C');
      } else {
        setState(() {
          _errorMessage = 'Tidak dapat mendapatkan lokasi';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshWeatherData() async {
    if (_currentPosition == null) return;

    try {
      // Check if data needs refresh
      if (_weatherService.needsRefresh) {
        print('Data needs refresh, fetching from API...');

        // Get synchronized weather data
        final weatherData = await _weatherService.getSynchronizedWeatherData(
          _currentPosition!['latitude']!,
          _currentPosition!['longitude']!,
          forceRefresh: true,
        );

        setState(() {
          _currentWeather = weatherData['current'] as WeatherModel;
          _forecast = weatherData['forecast'] as List<DailyForecast>;
        });

        // Animate background change
        _animateBackgroundChange();

        print('Weather data refreshed successfully');
        print('Current temperature: ${_currentWeather!.temperature}°C');
        print(
            'Today forecast: ${_forecast.first.maxTemp}°C / ${_forecast.first.minTemp}°C');
      } else {
        print('Data is still fresh, no refresh needed');
      }
    } catch (e) {
      print('Error refreshing weather data: $e');
      // Don't show error to user for auto refresh
    }
  }

  Future<void> _manualRefresh() async {
    if (_currentPosition == null) {
      await _loadWeatherData();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get synchronized weather data with force refresh
      final weatherData = await _weatherService.getSynchronizedWeatherData(
        _currentPosition!['latitude']!,
        _currentPosition!['longitude']!,
        forceRefresh: true,
      );

      setState(() {
        _currentWeather = weatherData['current'] as WeatherModel;
        _forecast = weatherData['forecast'] as List<DailyForecast>;
        _isLoading = false;
      });

      // Animate background change
      _animateBackgroundChange();

      print('Manual refresh completed');
      print('Current temperature: ${_currentWeather!.temperature}°C');
      print(
          'Today forecast: ${_forecast.first.maxTemp}°C / ${_forecast.first.minTemp}°C');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data cuaca berhasil diperbarui'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui data: $e'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await _weatherService.searchLocation(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  Future<void> _selectLocation(Location location) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _searchResults = [];
    });

    try {
      // Get synchronized weather data for selected location
      final weatherData = await _weatherService.getSynchronizedWeatherData(
        location.lat,
        location.lon,
      );

      setState(() {
        _currentWeather = weatherData['current'] as WeatherModel;
        _forecast = weatherData['forecast'] as List<DailyForecast>;
        _locationName = location.displayName;
        _isLoading = false;
      });

      // Update current position
      _currentPosition = {
        'latitude': location.lat,
        'longitude': location.lon,
      };

      // Animate background change
      _animateBackgroundChange();

      print('Location changed to: ${location.displayName}');
      print('Current temperature: ${_currentWeather!.temperature}°C');
      print(
          'Today forecast: ${_forecast.first.maxTemp}°C / ${_forecast.first.minTemp}°C');
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  List<Color> _getBackgroundColors() {
    if (_currentWeather != null) {
      final description = _currentWeather!.description.toLowerCase();
      final hour = _currentWeather!.date.hour;

      // Gradient menggunakan warna cerah seperti biru langit dan warna vibrant
      if (description.contains('hujan') || description.contains('rain')) {
        return [
          const Color(0xFF4FC3F7), // Biru langit cerah
          const Color(0xFF81D4FA), // Biru langit muda
          const Color(0xFFB3E5FC), // Biru langit sangat muda
        ];
      } else if (description.contains('mendung') ||
          description.contains('berawan') ||
          description.contains('cloud') ||
          description.contains('overcast')) {
        return [
          const Color(0xFF90A4AE), // Abu-abu biru cerah
          const Color(0xFFB0BEC5), // Abu-abu biru muda
          const Color(0xFFCFD8DC), // Abu-abu biru sangat muda
        ];
      } else if (description.contains('cerah') ||
          description.contains('matahari')) {
        if (hour >= 6 && hour <= 18) {
          // Siang hari - gradient matahari cerah
          return [
            const Color(0xFFFF9800), // Orange cerah
            const Color(0xFFFFB74D), // Orange muda cerah
            const Color(0xFFFFCC80), // Orange sangat muda cerah
          ];
        } else {
          // Pagi/sore - gradient matahari terbit/terbenam cerah
          return [
            const Color(0xFFFF5722), // Orange merah cerah
            const Color(0xFFFF8A65), // Orange merah muda cerah
            const Color(0xFFFFAB91), // Orange merah sangat muda cerah
          ];
        }
      } else if (description.contains('angin') ||
          description.contains('wind')) {
        return [
          const Color(0xFF4CAF50), // Hijau cerah
          const Color(0xFF66BB6A), // Hijau muda cerah
          const Color(0xFF81C784), // Hijau sangat muda cerah
        ];
      } else if (description.contains('salju') ||
          description.contains('snow')) {
        return [
          const Color(0xFFE3F2FD), // Biru putih cerah
          const Color(0xFFF3E5F5), // Ungu putih cerah
          const Color(0xFFFAFAFA), // Putih cerah
        ];
      } else if (description.contains('kabut') ||
          description.contains('fog') ||
          description.contains('mist')) {
        return [
          const Color(0xFFE0E0E0), // Abu-abu cerah
          const Color(0xFFEEEEEE), // Abu-abu sangat cerah
          const Color(0xFFF5F5F5), // Putih keabuan cerah
        ];
      } else {
        // Default berdasarkan waktu - warna cerah
        if (hour >= 6 && hour <= 18) {
          // Siang hari - biru langit cerah
          return [
            const Color(0xFF2196F3), // Biru langit cerah
            const Color(0xFF42A5F5), // Biru langit muda cerah
            const Color(0xFF64B5F6), // Biru langit sangat muda cerah
          ];
        } else {
          // Malam hari - biru malam cerah
          return [
            const Color(0xFF1976D2), // Biru malam cerah
            const Color(0xFF42A5F5), // Biru langit muda cerah
            const Color(0xFF90CAF9), // Biru langit sangat muda cerah
          ];
        }
      }
    } else {
      // Default gradient saat loading - biru langit cerah
      return [
        const Color(0xFF2196F3), // Biru langit cerah
        const Color(0xFF42A5F5), // Biru langit muda cerah
        const Color(0xFF64B5F6), // Biru langit sangat muda cerah
      ];
    }
  }

  List<Alignment> _getBackgroundAlignment() {
    if (_currentWeather != null) {
      final description = _currentWeather!.description.toLowerCase();

      if (description.contains('hujan') || description.contains('rain')) {
        return [Alignment.topCenter, Alignment.bottomCenter];
      } else if (description.contains('cerah') ||
          description.contains('matahari')) {
        return [Alignment.topLeft, Alignment.bottomRight];
      } else if (description.contains('angin') ||
          description.contains('wind')) {
        return [Alignment.topRight, Alignment.bottomLeft];
      } else {
        return [Alignment.topLeft, Alignment.bottomRight];
      }
    }
    return [Alignment.topLeft, Alignment.bottomRight];
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  String _getLastUpdateTime() {
    if (_currentWeather != null) {
      return _currentWeather!.lastUpdatedText;
    }
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  bool _isDataConsistent() {
    if (_currentWeather != null && _forecast.isNotEmpty) {
      return _currentWeather!.temperature == _forecast.first.maxTemp &&
          _currentWeather!.temperature == _forecast.first.minTemp;
    }
    return false;
  }

  double _getTemperatureDifference() {
    if (_currentWeather != null && _forecast.isNotEmpty) {
      return (_currentWeather!.temperature - _forecast.first.maxTemp).abs();
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: _getBackgroundAlignment()[0],
                end: _getBackgroundAlignment()[1],
                colors: _getBackgroundColors(),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // App Bar - Fixed height dengan desain yang lebih menarik dan scroll behavior
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isHeaderVisible ? 80 : 0,
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: _isHeaderVisible ? 8.0 : 0,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.25),
                          Colors.white.withOpacity(0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: _isHeaderVisible
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 12.0),
                            child: Row(
                              children: [
                                // Logo dan Nama Aplikasi
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.3),
                                            Colors.white.withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.wb_sunny,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Iklimku',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        Text(
                                          'Cuaca Indonesia',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                // Informasi waktu saat ini
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _getCurrentTime(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    Text(
                                      _getCurrentDate(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                // Tombol Refresh dengan animasi
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: _isRefreshHovered
                                          ? [
                                              Colors.white.withOpacity(0.4),
                                              Colors.white.withOpacity(0.2),
                                            ]
                                          : [
                                              Colors.white.withOpacity(0.3),
                                              Colors.white.withOpacity(0.1),
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: _isRefreshHovered
                                        ? [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.15),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: MouseRegion(
                                    onEnter: (_) => setState(
                                        () => _isRefreshHovered = true),
                                    onExit: (_) => setState(
                                        () => _isRefreshHovered = false),
                                    child: IconButton(
                                      onPressed: _manualRefresh,
                                      icon: AnimatedRotation(
                                        turns: _isLoading ? 1 : 0,
                                        duration: const Duration(seconds: 1),
                                        child: const Icon(
                                          Icons.refresh,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                      tooltip: 'Refresh Data Cuaca',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : null,
                  ),

                  // Search Bar - Fixed height
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Cari kota...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onChanged: _searchLocation,
                    ),
                  ),

                  // Hasil pencarian lokasi - Fixed max height
                  if (_searchResults.isNotEmpty && !_isLoading)
                    Container(
                      height: 80,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        itemCount: _searchResults.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final loc = _searchResults[index];
                          return ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 2),
                            title: Text(
                              loc.displayName,
                              style: const TextStyle(fontSize: 12),
                            ),
                            onTap: () => _selectLocation(loc),
                          );
                        },
                      ),
                    ),

                  // Content - Expanded dengan SingleChildScrollView
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Memuat data cuaca...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _errorMessage != null
                            ? _buildErrorWidget()
                            : _currentWeather != null
                                ? _buildWeatherContent()
                                : _buildWelcomeWidget(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // Floating Action Button untuk menampilkan header kembali
      floatingActionButton: !_isHeaderVisible
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isHeaderVisible = true;
                });
                // Scroll ke atas
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              backgroundColor: Colors.white.withOpacity(0.9),
              child: const Icon(
                Icons.keyboard_arrow_up,
                color: Color(0xFF2C3E50),
                size: 28,
              ),
            )
          : null,
    );
  }

  Widget _buildWeatherContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          // Current Weather Card
          WeatherCard(weather: _currentWeather!),

          const SizedBox(height: 12),

          // Location Name
          Text(
            _locationName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Status sinkronisasi dan waktu terakhir diperbarui
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _currentWeather != null && _currentWeather!.isDataFresh
                          ? Icons.sync
                          : Icons.sync_problem,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _currentWeather != null && _currentWeather!.isDataFresh
                          ? 'Tersinkronisasi'
                          : 'Perlu diperbarui',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• Terakhir: ${_getLastUpdateTime()}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                // Indikator konsistensi data
                if (_currentWeather != null && _forecast.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isDataConsistent()
                            ? Icons.check_circle
                            : Icons.warning,
                        color:
                            _isDataConsistent() ? Colors.green : Colors.orange,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isDataConsistent()
                            ? 'Data konsisten'
                            : 'Data tidak konsisten',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (!_isDataConsistent()) ...[
                        const SizedBox(width: 6),
                        Text(
                          '(${_getTemperatureDifference()}°C)',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Forecast
          if (_forecast.isNotEmpty) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Prakiraan 7 Hari',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _forecast.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedForecastIndex = index;
                      });
                    },
                    child: ForecastCard(
                      forecast: _forecast[index],
                      isSelected: index == _selectedForecastIndex,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Detail forecast yang dipilih
            ForecastDetailCard(
              forecast: _forecast[_selectedForecastIndex],
            ),

            const SizedBox(height: 16),

            // Analisis Cuaca
            WeatherAnalysisCard(
              weather: _currentWeather!,
              forecast: _forecast,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.white),
            const SizedBox(height: 12),
            const Text(
              'Oops!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Terjadi kesalahan',
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadWeatherData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wb_sunny, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'Selamat Datang di Iklimku',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Aplikasi cuaca terbaik untuk Indonesia',
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadWeatherData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Mulai'),
            ),
          ],
        ),
      ),
    );
  }
}
