//
//  WeatherViewModel.swift
//  Weather-App
//
//  Created by Himanshu Goswami on 7/29/26.

//
import Foundation
import SwiftUI
import Combine

class WeatherViewModel: ObservableObject {
    @Published var temperature: Double?
    @Published var windspeed: Double?
    @Published var errorMessage: String?
    
    var onUpdate: (() -> Void)?

    func setupCallback() {
        onUpdate = { [weak self] in
            print("Temperature updated: \(self?.temperature ?? 0)")
        }
    }

    func loadWeather(for city: String) async {
        guard let geocodingURL = URL(string: "https://geocoding-api.open-meteo.com/v1/search?name=\(city)&count=1") else {
            errorMessage = "Invalid URL"
            return
        }

        var latitude: Double = 0
        var longitude: Double = 0

        do {
            let (data, _) = try await URLSession.shared.data(from: geocodingURL)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode(GeocodingResponse.self, from: data)

            guard let firstResult = decoded.results?.first else {
                errorMessage = "City not found"
                return
            }
            latitude = firstResult.latitude
            longitude = firstResult.longitude
        } catch {
            errorMessage = "City not found"
            return
        }

        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true") else {
            errorMessage = "Invalid URL"
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode(WeatherResponse.self, from: data)

            temperature = decoded.currentWeather.temperature
            windspeed = decoded.currentWeather.windspeed
        } catch _ as DecodingError {
            errorMessage = "Couldn't understand the server's response"
        } catch let error as URLError {
            errorMessage = "Network error: \(error.localizedDescription)"
        } catch {
            errorMessage = "Failed to load weather"
        }
    }
}

