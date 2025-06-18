# Iklimku - Aplikasi Cuaca iOS

Iklimku adalah aplikasi cuaca modern yang dibangun dengan Swift dan SwiftUI untuk iOS. Aplikasi ini menyediakan informasi cuaca yang akurat dan real-time dengan antarmuka yang menarik dan mudah digunakan.

## 🌟 Fitur Utama

- **Cuaca Real-time**: Informasi cuaca terkini berdasarkan lokasi pengguna
- **Prakiraan 7 Hari**: Ramalan cuaca untuk 7 hari ke depan
- **Pencarian Kota**: Cari dan pilih kota untuk melihat cuaca di lokasi tertentu
- **Lokasi Otomatis**: Deteksi lokasi pengguna secara otomatis
- **UI Modern**: Antarmuka yang menarik dengan gradient dan efek blur
- **Bahasa Indonesia**: Interface dalam bahasa Indonesia
- **Detail Cuaca**: Informasi kelembaban, kecepatan angin, dan suhu terasa

## 📱 Screenshot

Aplikasi memiliki tampilan yang modern dengan:

- Background gradient yang menarik
- Kartu cuaca dengan efek glassmorphism
- Prakiraan harian dalam format horizontal scroll
- Search bar dengan autocomplete
- Loading dan error states yang informatif

## 🛠️ Teknologi yang Digunakan

- **SwiftUI**: Framework UI modern Apple
- **Core Location**: Untuk akses lokasi pengguna
- **OpenWeather API**: Untuk data cuaca real-time
- **Combine**: Untuk reactive programming
- **Async/Await**: Untuk operasi asynchronous

## 📋 Persyaratan Sistem

- iOS 17.0 atau lebih baru
- Xcode 15.0 atau lebih baru
- Swift 5.9 atau lebih baru
- Akses internet untuk data cuaca
- Izin lokasi untuk fitur lokasi otomatis

## 🚀 Instalasi

1. Clone repository ini:

```bash
git clone https://github.com/yourusername/Iklimku.git
cd Iklimku
```

2. Buka file `Iklimku.xcodeproj` di Xcode

3. Dapatkan API Key dari OpenWeather:

   - Kunjungi [OpenWeather API](https://openweathermap.org/api)
   - Daftar dan dapatkan API key gratis
   - Buka file `WeatherService.swift`
   - Ganti `YOUR_OPENWEATHER_API_KEY` dengan API key Anda

4. Build dan jalankan aplikasi di simulator atau device

## 🔧 Konfigurasi

### API Key Setup

Buka file `Iklimku/WeatherService.swift` dan ganti baris berikut:

```swift
private let apiKey = "YOUR_OPENWEATHER_API_KEY" // Ganti dengan API key Anda
```

### Permissions

Aplikasi membutuhkan izin lokasi. Pastikan `Info.plist` sudah berisi:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Aplikasi ini membutuhkan akses lokasi untuk menampilkan informasi cuaca yang akurat.</string>
```

## 📁 Struktur Proyek

```
Iklimku/
├── IklimkuApp.swift          # Entry point aplikasi
├── ContentView.swift         # View utama
├── WeatherView.swift         # View cuaca dengan UI lengkap
├── WeatherService.swift      # Service untuk API cuaca
├── WeatherModel.swift        # Model data cuaca
├── LocationManager.swift     # Manager lokasi
├── Info.plist               # Konfigurasi aplikasi
└── Assets.xcassets/         # Asset aplikasi
```

## 🎨 UI Components

### WeatherView

- Search bar dengan autocomplete
- Current weather card dengan gradient
- Daily forecast horizontal scroll
- Weather details cards
- Loading dan error states

### WeatherDetailCard

- Reusable component untuk detail cuaca
- Icon, title, dan value display
- Customizable colors

## 🔄 Data Flow

1. **LocationManager** mendeteksi lokasi pengguna
2. **WeatherService** mengambil data cuaca dari API
3. **WeatherView** menampilkan data dengan UI yang menarik
4. User dapat mencari kota lain melalui search bar

## 🌐 API Endpoints

Aplikasi menggunakan OpenWeather API:

- **Current Weather**: `/data/3.0/onecall`
- **Geocoding**: `/geo/1.0/direct`

## 🎯 Fitur Mendatang

- [ ] Notifikasi cuaca ekstrem
- [ ] Widget untuk iOS
- [ ] Dark mode
- [ ] Unit conversion (Celsius/Fahrenheit)
- [ ] Offline mode
- [ ] Multiple locations
- [ ] Weather maps
- [ ] Air quality index

## 🤝 Kontribusi

Kontribusi sangat diterima! Silakan:

1. Fork repository
2. Buat feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## 📄 Lisensi

Proyek ini dilisensikan di bawah MIT License - lihat file [LICENSE](LICENSE) untuk detail.

## 👨‍💻 Pengembang

Dibuat dengan ❤️ menggunakan Swift dan SwiftUI

## 📞 Support

Jika ada pertanyaan atau masalah, silakan buat issue di repository ini.

---

**Iklimku** - Cuaca Indonesia dalam genggaman Anda! 🌤️
