//
//  City.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 7.05.2025.
//

import Foundation

struct City: Codable {
    var name: String
    var lat: Double
    var lon: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case lat
        case lon
    }
}
