//
//  Forecast.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 6.03.2025.
//

import Foundation

struct WeatherModel: Codable {
    
    let city: String
    let temperature: Int32
    let maxTemp: Int32
    let minTemp: Int32
    let humidity: Int32
    let tempDescription: String
    
    static let mockWeatherData: [WeatherModel] = [WeatherModel(city: "İzmir", temperature: 20, maxTemp: 26, minTemp: 24, humidity: 68, tempDescription: "mostly sunny")]
}
