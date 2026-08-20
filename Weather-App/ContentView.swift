import Foundation
import SwiftUI

struct WeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    @State private var cityName: String = "Dallas"
    
    var body: some View {
        VStack {
            ForEach(viewModel.favoriteCities, id:\.self){ city in
                Button(city){
                    Task{
                        await viewModel.loadWeather(for: city)
                    }
                }
                
            }
                
            TextField("City", text: $cityName)
                .multilineTextAlignment(.center)   // centers the text WITHIN the field
                    .frame(maxWidth: .infinity)         // makes the field span the available width
                    .padding()
            Button("Search") {
                Task {
                    await viewModel.loadWeather(for: cityName)
                }
            }
            
            Button("Save to Favourites"){
                viewModel.addFavorite(cityName)
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else if let temp = viewModel.temperature, let wind = viewModel.windspeed {
                VStack {
                    let formatedtemp=String(format:"%.1f",temp)
                    let formatedwind=String(format: "%.1f",wind)
                    Text("\(formatedtemp) °C").foregroundColor(.orange)
                    Text("\(formatedwind) km/h")
                    List(viewModel.forecast) { day in
                        Text("\(day.date): \(String(format: "%.1f", day.high))° / \(String(format: "%.1f", day.low))°")
                    }
                }
            } else {
                ProgressView()
            }
        }
        .task {
            viewModel.loadFavorites()
            await viewModel.loadWeather(for: cityName)
        }
    }
}
