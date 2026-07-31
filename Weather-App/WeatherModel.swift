//
//  WeatherModel.swift
//  Weather-App
//
//  Created by Himanshu Goswami on 7/29/26.
//

struct WeatherResponse: Codable {
    let currentWeather: CurrentWeather
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
