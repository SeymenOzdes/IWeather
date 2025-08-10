//
//  NetworkManager.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 25.03.2025.
//
import Foundation

protocol UrlSessionProtocol {
    func data(from: URL) async throws -> (Data, URLResponse)
}

extension URLSession: UrlSessionProtocol {}

class NetworkManager {
    let apiKey = "75d7c6e989dbdb93c25fc219cf910d89"
    var urlSession: UrlSessionProtocol

    init(urlSession: UrlSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func fetchCurrentForecast(latitude: Double, longitude: Double) async throws -> Forecast {
        let endPoint = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        let url = URL(string: "\(endPoint)")

        guard let url = url else {
            throw networkError.invalidURL
        }

        let (data, _) = try await urlSession.data(from: url)
        let decoded = try JSONDecoder().decode(Forecast.self, from: data)
        return decoded
    }

    func fetchFiveDayForecast(latitude: Double, longitude: Double) async throws -> FiveDaysForecast {
        let endPoint = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        let url = URL(string: endPoint)

        guard let url = url else {
            throw networkError.invalidURL
        }

        let (data, _) = try await urlSession.data(from: url)
        let decoded = try JSONDecoder().decode(FiveDaysForecast.self, from: data)
        return decoded
    }

    func fetchCoordinates(city: String) async throws -> City {
        let endPoint = "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=2&appid=\(apiKey)"

        let url = URL(string: endPoint)

        guard let url = url else {
            throw networkError.invalidURL
        }

        let (data, _) = try await urlSession.data(from: url)
        let decodedCities = try JSONDecoder().decode([City].self, from: data)
        guard let firstCity = decodedCities.first else {
            throw networkError.noData
        }
        return firstCity
    }
}

enum networkError: Error {
    case invalidURL
    case noData
}
