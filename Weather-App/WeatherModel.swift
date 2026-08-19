//
//  WeatherModel.swift
//  Weather-App
//
//  Created by Himanshu Goswami on 7/29/26.
//
import Foundation

struct WeatherResponse: Codable {
    let currentWeather: CurrentWeather
    let daily: DailyWeather
    
    enum CodingKeys: String, CodingKey {
            case currentWeather = "current_weather"
            case daily
        }
}

struct CurrentWeather: Codable {
    let temperature: Double
    let windspeed: Double
}

struct GeocodingResponse: Codable {
    let results: [GeocodingResult]?
}

struct GeocodingResult: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
}

struct DailyWeather: Codable {
    let time: [String]
    let temperature2mMax: [Double]
    let temperature2mMin: [Double]
    
    enum CodingKeys: String, CodingKey {
            case time
            case temperature2mMax = "temperature_2m_max"
            case temperature2mMin = "temperature_2m_min"
        }
}

struct DayForecast: Identifiable {
    let id = UUID()
    let date: String
    let high: Double
    let low: Double
}
