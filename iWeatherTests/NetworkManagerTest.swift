//
//  NetworkManagerTest.swift
//  iWeatherTests
//
//  Created by Seymen Özdeş on 5.08.2025.
//

import XCTest

@testable import ForecastApp

final class MockUrlSession: UrlSessionProtocol {
    var shouldThrowError = false
    var dataToReturn: Data?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if shouldThrowError {
            throw networkError.noData
        }
        let urlResponse = HTTPURLResponse(url: url,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)

        return (dataToReturn ?? Data(), urlResponse!)
    }
}

final class NetworkManagerTest: XCTestCase {
    var mockUrlSession: MockUrlSession!
    var manager: NetworkManager!

    override func setUp() {
        super.setUp()
        mockUrlSession = MockUrlSession()
        manager = NetworkManager(urlSession: mockUrlSession)
    }

    override func tearDown() {
        mockUrlSession = nil
        manager = nil
        super.tearDown()
    }

    // success
    func testFetchCoordinates_WhenGivenValidJson_ReturnsCorrectCityData() async throws {
        // Arrange
        let json = """
        [ 
        {
          "name": "İstanbul", 
          "lat": 45.000,
          "lon": 35.000,
        } 
        ]
        """.data(using: .utf8)!
        mockUrlSession.dataToReturn = json

        // Act
        let city = try await manager.fetchCoordinates(city: "İstanbul")

        // Assert
        XCTAssertEqual(city.name, "İstanbul")
        XCTAssertEqual(city.lat, 45.000, accuracy: 0.0001)
        XCTAssertEqual(city.lon, 35.000, accuracy: 0.0001)
    }

    func testFetchCurrentForecast_WhenGivenValidJson_ReturnsCorrectForecastData() async throws {
        // Arrange
        let json = """
         {
          "name": "San Francisco", 
            "weather": [  
                 {
                  "id": 804,
                  "description": "sunny"
                 }
            ], 
            "main": {
                "temp": 21.73,
                "temp_min": 20.61,
                "temp_max": 23.23
            }
         }
        """.data(using: .utf8)
        mockUrlSession.dataToReturn = json

        // Act
        let forecast = try await manager.fetchCurrentForecast(latitude: 20.000, longitude: 12.000)

        // Assert
        XCTAssertEqual(forecast.name, "San Francisco")
        XCTAssertEqual(forecast.weather.first?.id, 804)
        XCTAssertEqual(forecast.weather.first?.description, "sunny")
        XCTAssertEqual(forecast.main.temp, 21.73)
        XCTAssertEqual(forecast.main.temp_min, 20.61)
        XCTAssertEqual(forecast.main.temp_max, 23.23)
    }

    func testFetchFiveDayForecast_whenGivenValidJson_ReturnsCorrectForecastData() async throws {
        let json = """
        {
          "list": [
            {
              "main": {
                "temp_min": 14.23,
                "temp_max": 16.42
              },
              "weather": [
                {
                  "icon": "04d"
                }
              ],
              "dt_txt": "2025-08-07 15:00:00"
            }
          ]
        }
        """.data(using: .utf8)!

        mockUrlSession.dataToReturn = json

        let fiveDayForecast = try await manager.fetchFiveDayForecast(latitude: 12.000, longitude: 8.000)

        XCTAssertEqual(fiveDayForecast.list[0].main.temp_min, 14.23)
        XCTAssertEqual(fiveDayForecast.list[0].main.temp_max, 16.42)
        XCTAssertEqual(fiveDayForecast.list[0].weather.first?.icon, "04d")
        XCTAssertEqual(fiveDayForecast.list[0].dt_txt, "2025-08-07 15:00:00")
    }
    
    // failure - noData
    func testFetchCoordinates_WhenSessionThrowError_ThrowsNoData() async throws {
        mockUrlSession.shouldThrowError = true

        do {
            _ = try await manager.fetchCoordinates(city: "Berlin")
            XCTFail("Expected to throw error but succeeded")
        } catch {
            XCTAssertEqual(error as? networkError, networkError.noData)
        }
    }
    
    func testCurrentForecast_WhenSessionThrowError_ThrowsNoData() async throws {
        mockUrlSession.shouldThrowError = true

        do {
            _ = try await manager.fetchCurrentForecast(latitude: 20.000, longitude: 12.000)
            XCTFail("Expected to throw error but succeeded")
        } catch {
            XCTAssertEqual(error as? networkError, networkError.noData)
        }
    }
    
    func testFiveDayForecast_WhenSessionThrowError_ThrowsNoData() async throws {
        mockUrlSession.shouldThrowError = true

        do {
            _ = try await manager.fetchFiveDayForecast(latitude: 20.000, longitude: 12.000)
            XCTFail("Expected to throw error but succeeded")
        } catch {
            XCTAssertEqual(error as? networkError, networkError.noData)
        }
    }
    
    // failure - malFormedJson
    func testFetchCoordinates_WhenMalformedJson_ThrowsDecodingError() async {
        let malformedJson = """
        {
          "invalid_field": 123
        }
        """.data(using: .utf8)!
        
        mockUrlSession.dataToReturn = malformedJson
        
        do {
            _ = try await manager.fetchCoordinates(city: "paris")
            XCTFail("Expected decoding error")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }

    func testFetchCurrentForecast_WhenMalformedJson_ThrowsDecodingError() async {
        let malformedJson = """
        {
          "invalid_field": 123
        }
        """.data(using: .utf8)!
        
        mockUrlSession.dataToReturn = malformedJson
        
        do {
            _ = try await manager.fetchCurrentForecast(latitude: 0.0, longitude: 0.0)
            XCTFail("Expected decoding error")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testFetchFiveDayForecast_WhenMalformedJson_ThrowsDecodingError() async {
        let malformedJson = """
        {
          "invalid_field": 123
        }
        """.data(using: .utf8)!
        
        mockUrlSession.dataToReturn = malformedJson
        
        do {
            _ = try await manager.fetchFiveDayForecast(latitude: 0.0, longitude: 0.0)
            XCTFail("Expected decoding error")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
}
