//
//  NetworkManager.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 25.03.2025.
//
import Foundation

// api call


class NetworkManager {
    let apiKey = "75d7c6e989dbdb93c25fc219cf910d89"
    
    func fetchCurrentForecast(latitude: Double, longitude: Double) async throws -> WeatherModel {
        let endPoint = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        let url = URL(string: "\(endPoint)")
        
        guard let url = url else {
            throw networkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(WeatherModel.self, from: data)
        return decoded
    }
    
}

enum networkError: Error {
    case invalidURL
}
