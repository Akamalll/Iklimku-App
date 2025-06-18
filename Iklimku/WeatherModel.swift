import Foundation

// Model untuk data cuaca saat ini
struct CurrentWeather: Codable {
    let temp: Double
    let feels_like: Double
    let humidity: Int
    let wind_speed: Double
    let weather: [WeatherDescription]
    let dt: TimeInterval
    
    var temperature: String {
        return "\(Int(round(temp)))°"
    }
    
    var feelsLike: String {
        return "\(Int(round(feels_like)))°"
    }
    
    var humidityText: String {
        return "\(humidity)%"
    }
    
    var windSpeed: String {
        return "\(Int(round(wind_speed))) km/h"
    }
    
    var weatherDescription: String {
        return weather.first?.description.capitalized ?? ""
    }
    
    var weatherIcon: String {
        return weather.first?.icon ?? ""
    }
    
    var date: Date {
        return Date(timeIntervalSince1970: dt)
    }
}

// Model untuk deskripsi cuaca
struct WeatherDescription: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// Model untuk data cuaca harian
struct DailyWeather: Codable {
    let dt: TimeInterval
    let temp: Temperature
    let weather: [WeatherDescription]
    
    var date: Date {
        return Date(timeIntervalSince1970: dt)
    }
    
    var dayName: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    var dayShort: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    var maxTemp: String {
        return "\(Int(round(temp.max)))°"
    }
    
    var minTemp: String {
        return "\(Int(round(temp.min)))°"
    }
    
    var weatherIcon: String {
        return weather.first?.icon ?? ""
    }
}

// Model untuk temperatur
struct Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

// Model untuk response API cuaca
struct WeatherResponse: Codable {
    let current: CurrentWeather
    let daily: [DailyWeather]
    let timezone: String
    
    var locationName: String {
        return timezone.replacingOccurrences(of: "_", with: " ")
    }
}

// Model untuk lokasi
struct Location: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
    
    var displayName: String {
        if let state = state {
            return "\(name), \(state)"
        }
        return "\(name), \(country)"
    }
} 