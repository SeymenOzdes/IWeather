//
//  Forecast.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 6.03.2025.
//

import Foundation

struct Forecast: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
    
    struct Weather: Codable {
        let id: Int
        let description: String
    }
    struct Main: Codable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
    }
    
    static let mockWeatherData: [Forecast] = [
        Forecast(
            name: "İzmir",
            weather: [Weather(id: 800, description: "mostly sunny")],
            main: Main(temp: 20, temp_min: 24, temp_max: 26)
        ),
        Forecast(
            name: "İstanbul",
            weather: [Weather(id: 803, description: "cloudly")],
            main: Main(temp: 14, temp_min: 2, temp_max: 13)
        )
    ]
}
