//
//  FiveDaysForecast.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 25.04.2025.
//

struct FiveDaysForecast: Codable {
    let list: [List]
    
    struct List: Codable {
        let main: Main
        let weather: [Weather]
        let dt_txt: String
        
        struct Main: Codable {
            let temp_min: Double
            let temp_max: Double
        }
        struct Weather: Codable {
            let icon: String
        }
    }
}
