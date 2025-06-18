# Sistem Warna Iklimku - Versi 2.0

## 🎨 Palet Warna Baru

Aplikasi Iklimku telah diperbarui dengan sistem warna yang lebih menarik, harmonis, dan dinamis. Berikut adalah detail palet warna yang digunakan:

## 🌈 Warna Berdasarkan Kondisi Cuaca

### 1. **Hujan** - `#5B9BD5`

- **Deskripsi:** Biru hujan yang soft dan menenangkan
- **Penggunaan:** Background, border, shadow untuk kondisi hujan
- **Konteks:** Memberikan kesan sejuk dan segar

### 2. **Mendung/Berawan** - `#8E8E93`

- **Deskripsi:** Abu-abu yang elegan dan netral
- **Penggunaan:** Kondisi cuaca mendung atau berawan
- **Konteks:** Memberikan kesan tenang dan stabil

### 3. **Cerah/Matahari** - `#FF9500`

- **Deskripsi:** Orange yang vibrant dan energik
- **Penggunaan:** Cuaca cerah dan matahari terik
- **Konteks:** Memberikan kesan hangat dan bersemangat

### 4. **Angin** - `#34C759`

- **Deskripsi:** Hijau yang segar dan natural
- **Penggunaan:** Kondisi berangin
- **Konteks:** Memberikan kesan segar dan alami

### 5. **Salju** - `#AFE1FF`

- **Deskripsi:** Biru muda yang lembut
- **Penggunaan:** Kondisi bersalju
- **Konteks:** Memberikan kesan dingin dan bersih

### 6. **Kabut** - `#C7C7CC`

- **Deskripsi:** Abu-abu muda yang misterius
- **Penggunaan:** Kondisi berkabut
- **Konteks:** Memberikan kesan misterius dan tenang

## ⏰ Warna Berdasarkan Waktu

### Siang Hari (06:00-18:00)

- **Primary:** `#FF9500` (Orange cerah)
- **Konteks:** Memberikan energi dan kehangatan

### Malam Hari

- **Primary:** `#007AFF` (Biru malam)
- **Konteks:** Memberikan ketenangan dan kedamaian

## 🎯 Sistem Opacity

### Background Colors

- **Primary Background:** `Colors.white.withOpacity(0.98)`
- **Secondary Background:** `weatherColor.withOpacity(0.08-0.15)`
- **Selected State:** `weatherColor.withOpacity(0.15-0.25)`

### Border Colors

- **Default Border:** `Colors.grey.withOpacity(0.1)`
- **Selected Border:** `weatherColor.withOpacity(0.4)`
- **Active Border:** `weatherColor.withOpacity(0.25)`

### Shadow Colors

- **Default Shadow:** `Colors.black.withOpacity(0.06)`
- **Hover Shadow:** `weatherColor.withOpacity(0.25)`
- **Active Shadow:** `weatherColor.withOpacity(0.15)`

## 🔄 Gradient System

### Background Gradients

```dart
// Weather Screen Background
[
  primaryColor,
  primaryColor.withOpacity(0.8),
  primaryColor.withOpacity(0.6),
]

// Card Backgrounds
[
  Colors.white.withOpacity(0.98),
  weatherColor.withOpacity(0.08-0.15),
]
```

### Icon Backgrounds

```dart
// Radial Gradient untuk Icons
[
  weatherColor.withOpacity(0.25-0.3),
  weatherColor.withOpacity(0.08-0.1),
]
```

## 📱 Komponen Warna

### 1. **ForecastCard**

- **Background:** Gradient dengan opacity dinamis
- **Border:** Warna cuaca dengan opacity 0.4 saat selected
- **Shadow:** Warna cuaca dengan opacity 0.25 saat hover
- **Icon Background:** Radial gradient dengan warna cuaca

### 2. **WeatherCard**

- **Background:** Gradient putih ke warna cuaca
- **Border:** Warna cuaca dengan opacity 0.2
- **Shadow:** Warna cuaca dengan opacity 0.15
- **Temperature:** Warna cuaca solid
- **Details:** Warna cuaca dengan opacity 0.7

### 3. **ForecastDetailCard**

- **Background:** Gradient putih ke warna cuaca
- **Border:** Warna cuaca dengan opacity 0.25
- **Shadow:** Warna cuaca dengan opacity 0.12
- **Header:** Warna cuaca solid
- **Temperature:** Warna cuaca dengan variasi opacity

### 4. **WeatherScreen**

- **Background:** Gradient 3-tone berdasarkan cuaca
- **Text:** Putih untuk kontras optimal
- **Search Bar:** Putih dengan opacity 0.9

## 🎨 Color Psychology

### **Orange (#FF9500)**

- **Emosi:** Energi, kehangatan, optimisme
- **Konteks:** Cuaca cerah, siang hari
- **Efek:** Meningkatkan mood dan semangat

### **Blue (#5B9BD5, #007AFF)**

- **Emosi:** Ketenangan, kepercayaan, stabilitas
- **Konteks:** Hujan, malam hari
- **Efek:** Menenangkan dan menyejukkan

### **Green (#34C759)**

- **Emosi:** Pertumbuhan, alam, kesegaran
- **Konteks:** Angin, udara segar
- **Efek:** Memberikan kesan alami dan sehat

### **Gray (#8E8E93, #C7C7CC)**

- **Emosi:** Netral, tenang, profesional
- **Konteks:** Mendung, kabut
- **Efek:** Memberikan keseimbangan dan ketenangan

## 🔧 Implementasi Teknis

### Fungsi Helper

```dart
Color _getWeatherColor() {
  // Logic untuk menentukan warna berdasarkan cuaca
}

Color _getBackgroundColor() {
  // Logic untuk background dengan opacity
}

Color _getBorderColor() {
  // Logic untuk border dengan opacity
}

Color _getShadowColor() {
  // Logic untuk shadow dengan opacity
}
```

### Responsive Colors

- **Light Mode:** Opacity tinggi untuk kontras
- **Dark Mode:** Opacity rendah untuk kelembutan
- **Hover State:** Opacity meningkat untuk feedback

## 📊 Accessibility

### Contrast Ratios

- **Text on White:** Minimum 4.5:1
- **Text on Color:** Minimum 3:1
- **Interactive Elements:** Minimum 3:1

### Color Blind Friendly

- **Primary Colors:** Berbeda dalam brightness dan saturation
- **Secondary Colors:** Komplementer yang jelas
- **Icons:** Disertai dengan text labels

## 🚀 Best Practices

1. **Konsistensi:** Gunakan warna yang sama untuk kondisi cuaca yang sama
2. **Hierarchy:** Gunakan opacity untuk menciptakan visual hierarchy
3. **Feedback:** Gunakan perubahan warna untuk user feedback
4. **Accessibility:** Pastikan kontras yang cukup untuk readability
5. **Performance:** Gunakan opacity daripada membuat warna baru

## 📈 Metrics

### Warna yang Digunakan

- **Primary Colors:** 6 warna cuaca
- **Time-based Colors:** 2 warna (siang/malam)
- **Opacity Levels:** 8 tingkat opacity
- **Gradient Types:** 3 jenis gradient

### Coverage

- **ForecastCard:** 100% warna dinamis
- **WeatherCard:** 100% warna dinamis
- **ForecastDetailCard:** 100% warna dinamis
- **WeatherScreen:** 100% background dinamis
