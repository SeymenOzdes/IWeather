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
        let baseUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        let url = URL(string: "\(baseUrl)")
        
        guard let url = url else {
            throw NSError(domain: "Create URL Error", code: 2, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("API JSON Yanıtı: \(jsonString)")
        }
        
        let decoded = try JSONDecoder().decode(WeatherModel.self, from: data)
        return decoded
    }
}
