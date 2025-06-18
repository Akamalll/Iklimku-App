import Foundation
import CoreLocation

class WeatherService: ObservableObject {
    private let apiKey = "7ddd5ad51734ffd89cb3ce26116b5c4b" // Ganti dengan API key Anda
    private let baseURL = "https://api.openweathermap.org/data/3.0"
    
    @Published var currentWeather: CurrentWeather?
    @Published var dailyForecast: [DailyWeather] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchWeatherData(latitude: Double, longitude: Double) {
        isLoading = true
        errorMessage = nil
        
        let urlString = "\(baseURL)/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,hourly,alerts&units=metric&appid=\(apiKey)&lang=id"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "URL tidak valid"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "Tidak ada data yang diterima"
                    return
                }
                
                do {
                    let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    self?.currentWeather = weatherResponse.current
                    self?.dailyForecast = Array(weatherResponse.daily.prefix(7)) // Ambil 7 hari
                } catch {
                    self?.errorMessage = "Gagal memparse data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func searchLocation(query: String) async -> [Location] {
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(query)&limit=5&appid=\(apiKey)"
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString.replacingOccurrences(of: query, with: encodedQuery)) else {
            return []
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let locations = try JSONDecoder().decode([Location].self, from: data)
            return locations
        } catch {
            print("Error searching location: \(error)")
            return []
        }
    }
    
    // Mock data untuk testing
    func loadMockData() {
        let mockCurrentWeather = CurrentWeather(
            temp: 28.5,
            feels_like: 30.2,
            humidity: 75,
            wind_speed: 12.5,
            weather: [WeatherDescription(id: 800, main: "Clear", description: "cerah", icon: "01d")],
            dt: Date().timeIntervalSince1970
        )
        
        let mockDailyWeather = [
            DailyWeather(
                dt: Date().timeIntervalSince1970,
                temp: Temperature(day: 28.5, min: 24.0, max: 32.0, night: 25.0, eve: 27.0, morn: 26.0),
                weather: [WeatherDescription(id: 800, main: "Clear", description: "cerah", icon: "01d")]
            ),
            DailyWeather(
                dt: Date().addingTimeInterval(86400).timeIntervalSince1970,
                temp: Temperature(day: 29.0, min: 25.0, max: 33.0, night: 26.0, eve: 28.0, morn: 27.0),
                weather: [WeatherDescription(id: 801, main: "Clouds", description: "berawan", icon: "02d")]
            )
        ]
        
        self.currentWeather = mockCurrentWeather
        self.dailyForecast = mockDailyWeather
    }
} 