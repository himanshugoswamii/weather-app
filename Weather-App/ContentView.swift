import Foundation
import SwiftUI

struct WeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    @State private var cityName: String = "Dallas"
    
    var body: some View {
        VStack {
            TextField("City", text: $cityName)
                .multilineTextAlignment(.center)   // centers the text WITHIN the field
                    .frame(maxWidth: .infinity)         // makes the field span the available width
                    .padding()
            Button("Search") {
                Task {
                    await viewModel.loadWeather(for: cityName)
                }
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else if let temp = viewModel.temperature, let wind = viewModel.windspeed {
                VStack {
                    let formatedtemp=String(format:"%.1f",temp)
                    let formatedwind=String(format: "%.1f",wind)
                    Text("\(formatedtemp) °C")
                    Text("\(formatedwind) km/h")
                }
            } else {
                ProgressView()
            }
        }
        .task {
            await viewModel.loadWeather(for: cityName)
        }
    }
}
