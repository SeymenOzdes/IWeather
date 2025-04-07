//
//  NetworkManager.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 25.03.2025.
//
import Foundation


class NetworkManager {
    let apiKey = "75d7c6e989dbdb93c25fc219cf910d89"
    let baseUrl: String
    
    init() {
        baseUrl = "http://api.openweathermap.org/data/2.5/forecast?id&appid={\(apiKey)}"
    }
}
