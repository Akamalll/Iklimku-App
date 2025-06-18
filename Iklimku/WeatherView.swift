import SwiftUI

struct WeatherView: View {
    @StateObject private var weatherService = WeatherService()
    @StateObject private var locationManager = LocationManager()
    @State private var searchText = ""
    @State private var searchResults: [Location] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.cyan.opacity(0.6), Color.white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        searchBar
                        
                        if weatherService.isLoading || locationManager.isLoading {
                            loadingView
                        } else if let error = weatherService.errorMessage ?? locationManager.errorMessage {
                            errorView(message: error)
                        } else if let currentWeather = weatherService.currentWeather {
                            currentWeatherCard(weather: currentWeather)
                            dailyForecastView
                            weatherDetailsView(weather: currentWeather)
                        } else {
                            welcomeView
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Iklimku")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                locationManager.startLocationUpdates()
            }
            .onChange(of: locationManager.location) { location in
                if let location = location {
                    weatherService.fetchWeatherData(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude
                    )
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Cari kota...", text: $searchText)
                    .onChange(of: searchText) { query in
                        if !query.isEmpty {
                            searchLocations(query: query)
                        } else {
                            searchResults = []
                        }
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        searchResults = []
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(12)
            .background(Color.white.opacity(0.9))
            .cornerRadius(25)
            
            Button(action: {
                locationManager.startLocationUpdates()
            }) {
                Image(systemName: "location.fill")
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.blue.opacity(0.8))
                    .clipShape(Circle())
            }
        }
    }
    
    private func currentWeatherCard(weather: CurrentWeather) -> some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text(weather.temperature)
                    .font(.system(size: 72, weight: .thin))
                    .foregroundColor(.white)
                
                Text(weather.weatherDescription)
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.9))
            }
            
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weatherIcon)@2x.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
            } placeholder: {
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Text("Terasa seperti \(weather.feelsLike)")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.2))
        )
    }
    
    private var dailyForecastView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Prakiraan 7 Hari")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(weatherService.dailyForecast, id: \.dt) { day in
                        VStack(spacing: 12) {
                            Text(day.dayShort)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(day.weatherIcon)@2x.png")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                            } placeholder: {
                                Image(systemName: "cloud.sun.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            VStack(spacing: 4) {
                                Text(day.maxTemp)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text(day.minTemp)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.2))
                        )
                        .frame(width: 80)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private func weatherDetailsView(weather: CurrentWeather) -> some View {
        VStack(spacing: 16) {
            Text("Detail Cuaca")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            HStack(spacing: 20) {
                WeatherDetailCard(
                    icon: "humidity.fill",
                    title: "Kelembaban",
                    value: weather.humidityText,
                    color: .blue
                )
                
                WeatherDetailCard(
                    icon: "wind",
                    title: "Angin",
                    value: weather.windSpeed,
                    color: .green
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.2))
        )
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
            
            Text("Memuat data cuaca...")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.8))
            
            Text("Oops!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(message)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
            
            Button("Coba Lagi") {
                locationManager.startLocationUpdates()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.3))
            .foregroundColor(.white)
            .cornerRadius(25)
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.2))
        )
    }
    
    private var welcomeView: some View {
        VStack(spacing: 30) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 100))
                .foregroundColor(.white.opacity(0.8))
            
            VStack(spacing: 16) {
                Text("Selamat Datang di Iklimku")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Aplikasi cuaca terbaik untuk Indonesia")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
            }
            
            Button("Mulai") {
                locationManager.startLocationUpdates()
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(Color.white.opacity(0.3))
            .foregroundColor(.white)
            .cornerRadius(30)
            .font(.headline)
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.2))
        )
    }
    
    private func searchLocations(query: String) {
        Task {
            let results = await weatherService.searchLocation(query: query)
            await MainActor.run {
                searchResults = results
            }
        }
    }
}

struct WeatherDetailCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.15))
        )
    }
}

#Preview {
    WeatherView()
} 