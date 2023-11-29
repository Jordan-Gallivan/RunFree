//
//  WeatherView.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/17/23.
//

import Foundation
import SwiftUI

struct WeatherView: View {
    @EnvironmentObject private var appData: AppData
    
    @StateObject var weatherData = FetchWeather()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Group {
            switch weatherData.result {
            case .empty:
//                Text("ABC")
                EmptyView()
            case .inProgress:
//                Text("ABC")
                WeatherLoadingView()
            case let .success(weather):
                List {
                    CurrentWeatherView(metar: weather.metar, colorScheme: colorScheme)  // TODO: Update Night
                    ForEach(weather.taf.forecasts, id: \.self) { forecast in
                            ForecastLine(forecast: forecast, colorScheme: colorScheme)  // TODO: do i need a $ infront of colorScheme???
                        }
                }
                .padding(.top, 30)
                .frame(maxWidth: .infinity)
                .listStyle(.plain)
                .navigationTitle(Text("Weather"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            appData.viewPath.append("Settings View")
                        }, label: {
                            Image(systemName: "gear")
                        })
                    }
                }
            case let .failure(error):
                Text("ABEFC")
//                WeatherErrorView(errorMessage: error?.localizedDescription)
            }
        }
        .task {
            await self.weatherData.reload()
        }
        .refreshable {
            await self.weatherData.reload()
        }
    }
    
}
