//
//  Forecast.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 6.03.2025.
//

import Foundation

struct WeatherModel: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
    
    struct Weather: Codable {
        let id: Int
        let description: String
    }
    struct Main: Codable {
        let temp: Int32
        let temp_min: Int32
        let temp_max: Int32
    }
    
    static let mockWeatherData: [WeatherModel] = [
        WeatherModel(
            name: "İzmir",
            weather: [Weather(id: 800, description: "mostly sunny")],
            main: Main(temp: 20, temp_min: 24, temp_max: 26)
        ),
        WeatherModel(
            name: "İstanbul",
            weather: [Weather(id: 803, description: "cloudly")],
            main: Main(temp: 14, temp_min: 2, temp_max: 13)
        )
    ]
}
