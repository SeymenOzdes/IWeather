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
    let baseUrl: String
    
    init() {
        baseUrl = "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={\(apiKey)}"
    }
    
    func fetchCurrentForecast() async throws {
        let url = URL(string: "\(baseUrl)")
        guard let url = url else {return}
        
        let (data, _) = try await URLSession.shared.data(from: url)
    }
}
