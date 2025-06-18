# Iklimku - Aplikasi Cuaca Flutter (Windows Compatible)

Versi Flutter dari aplikasi Iklimku yang dapat dijalankan di Windows, macOS, Linux, Android, dan iOS.

## 🚀 Cara Menjalankan di Windows

### 📋 Prasyarat:

1. **Flutter SDK** (versi 3.0.0 atau lebih baru)
2. **Android Studio** atau **VS Code**
3. **Android Emulator** atau **Chrome** (untuk web)
4. **Git** untuk version control

### 🔧 Instalasi Flutter di Windows:

#### 1. **Download Flutter SDK**

```bash
# Download dari https://flutter.dev/docs/get-started/install/windows
# Extract ke folder, misalnya: C:\flutter
```

#### 2. **Setup Environment Variables**

```bash
# Tambahkan ke PATH: C:\flutter\bin
# Restart Command Prompt/PowerShell
```

#### 3. **Verify Installation**

```bash
flutter doctor
```

#### 4. **Install Dependencies**

```bash
# Di folder proyek
flutter pub get
```

### 🎯 Menjalankan Aplikasi:

#### **Untuk Android Emulator:**

```bash
# Pastikan emulator sudah running
flutter run
```

#### **Untuk Chrome (Web):**

```bash
flutter run -d chrome
```

#### **Untuk Windows Desktop:**

```bash
flutter run -d windows
```

### 🔑 Setup API Key:

1. **Buat file `.env`** di root folder:

```env
OPENWEATHER_API_KEY=YOUR_ACTUAL_API_KEY_HERE
```

2. **Dapatkan API Key** dari [OpenWeather](https://openweathermap.org/api)

### 📱 Platform Support:

- ✅ **Android** (emulator/device)
- ✅ **iOS** (via macOS)
- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **Windows Desktop**
- ✅ **macOS Desktop**
- ✅ **Linux Desktop**

## 🛠️ Struktur Proyek Flutter:

```
lib/
├── main.dart                 # Entry point
├── models/
│   └── weather_model.dart    # Data models
├── services/
│   ├── weather_service.dart  # API service
│   └── location_service.dart # Location service
├── screens/
│   └── weather_screen.dart   # Main screen
└── widgets/
    ├── weather_card.dart     # Weather display
    ├── forecast_card.dart    # Forecast display
    └── search_bar.dart       # Search functionality
```

## 🌟 Fitur yang Tersedia:

1. **Cuaca Real-time** dengan lokasi otomatis
2. **Prakiraan 7 Hari** dengan scroll horizontal
3. **Pencarian Kota** dengan autocomplete
4. **UI Responsive** untuk semua platform
5. **Offline Support** dengan cached data
6. **Dark/Light Mode** (dapat dikembangkan)

## 🔧 Troubleshooting Windows:

### **Flutter Doctor Issues:**

```bash
# Install Android Studio
# Install Android SDK
# Accept licenses
flutter doctor --android-licenses
```

### **Permission Issues:**

```bash
# Run as Administrator jika diperlukan
# Pastikan antivirus tidak memblokir
```

### **Network Issues:**

```bash
# Periksa firewall settings
# Pastikan koneksi internet stabil
```

## 📊 Performance Tips:

1. **Hot Reload**: Gunakan `r` di terminal untuk hot reload
2. **Hot Restart**: Gunakan `R` untuk hot restart
3. **Debug Mode**: Gunakan `flutter run --debug`
4. **Release Mode**: Gunakan `flutter run --release`

## 🚀 Deployment:

### **Android APK:**

```bash
flutter build apk --release
```

### **Web:**

```bash
flutter build web
```

### **Windows:**

```bash
flutter build windows
```

## 💡 Keuntungan Flutter di Windows:

1. **Cross-Platform**: Satu kode untuk semua platform
2. **Hot Reload**: Development cepat
3. **Rich Ecosystem**: Banyak package tersedia
4. **Performance**: Native performance
5. **Material Design**: UI yang konsisten

## 🔄 Migrasi dari iOS Native:

Jika Anda ingin migrasi dari versi iOS native:

1. **Data Models**: Sudah dikonversi ke Dart
2. **API Calls**: Menggunakan http package
3. **UI Components**: Menggunakan Flutter widgets
4. **State Management**: Menggunakan setState (bisa upgrade ke Provider/Bloc)

## 📞 Support:

- **Flutter Documentation**: https://flutter.dev/docs
- **Dart Documentation**: https://dart.dev/guides
- **OpenWeather API**: https://openweathermap.org/api

---

**Iklimku Flutter** - Cuaca Indonesia di semua platform! 🌤️📱💻
