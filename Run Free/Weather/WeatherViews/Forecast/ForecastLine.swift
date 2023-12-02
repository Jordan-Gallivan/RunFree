//
//  ForecastLine.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/17/23.
//

import Foundation
import SwiftUI

struct ForecastLine: View {
    @EnvironmentObject private var appData: AppData
    
    var forecast: Forecast
    var weatherIcon: Image
    var weatherIconColors: [Color]
    var windIcon: Image? = nil
    var probability: Text? = nil
    var backgroundColor: Color
    var expandedView: Bool
    
    var forecastTimeFormat: DateFormatter {
        let formatter = DateFormatter()
        if appData.twelveHourClock {
            formatter.dateFormat = "h:mm a"
            return formatter
        } else {
            formatter.dateFormat = "HH:mm"
            return formatter
        }
    }
    
    /*
     
     | time     windIcon?   prob?   precipString    precipIcon/cloud    |
     
     */
    
    var body: some View {
        HStack {
            // Time
            Text(self.forecastTimeFormat.string(from: self.forecast.dateObject))
                .font(.title2)
            Spacer()
            
            // Wind
            if self.expandedView,
               let windDirection = forecast.windDirection,
               let windSpeed = forecast.convertedWindSpeed(metric: appData.metric) {
                VStack {
                    HStack {
                        WeatherImageGenerator.windIcon
                            .font(.footnote)
                        Text(windDirection)
                            .font(.caption2)
                    }
                    HStack {
                        Text("at")
                            .font(.caption2)
                        Text("\(windSpeed)\(appData.metric ? "kph" : "mph")")
                            .font(.footnote)
                    }
                }
                Spacer()
            } else {
                if let windIcon {
                    windIcon
                        .font(.title2)
                    Spacer()
                }
            }
            
            // Probability
            if let probability {
                if self.expandedView {
                    HStack {
                        probability
                            .font(.callout)
                        Text("chance of")
                            .font(.footnote)
                    }
                } else {
                    probability
                        .font(.callout)
                }
                Spacer()
            }
            
            // Sunrise/sunset or precipitation string
            if forecast.sunset {
                Text("Sunset")
                Spacer()
            } else if forecast.sunrise {
                Text("Sunrise")
                Spacer()
            } else {
                if let precipitation = forecast.precipitation {
                    if self.expandedView {
                        VStack {
                            ForEach(precipitation) { precip in
                                Text(precip.description)
                                    .font(.footnote)
                            }
                        }
                    } else {
                        Text(precipitation[0].description)
                            // TODO: size text to fit
                    }
                    Spacer()
                }
            }
            
            // Weather Icon
            weatherIcon
                .font(.title2)
                .foregroundStyle(self.weatherIconColors[0], self.weatherIconColors[1], self.weatherIconColors[2])
        }
        .padding([.horizontal], 10)
        .padding([.vertical], 7)
        .background(self.backgroundColor)
        .frame(maxWidth: .infinity)
    }
    
    init(forecast: Forecast, colorScheme: ColorScheme, expandedView: Bool = false) {
        self.expandedView = expandedView
        self.backgroundColor = forecast.backgroundColor
        
        if forecast.sunrise {
            self.weatherIcon = WeatherImageGenerator.generateSunriseSunsetImage(sunrise: true, colorScheme: colorScheme)
            self.weatherIconColors = [.primary, .yellow, .primary]
            self.forecast = forecast
            return
        } else if forecast.sunset {
            self.weatherIcon = WeatherImageGenerator.generateSunriseSunsetImage(sunset: true, colorScheme: colorScheme)
            self.weatherIconColors = [.primary, .yellow, .primary]
            self.forecast = forecast
            return
        }
        
        if forecast.windIcon {
            self.windIcon = WeatherImageGenerator.windIcon
        }
        
        if let prob = forecast.probability {
            self.probability = Text(String(prob) + "%")
        }
        
        let clouds = forecast.clouds ?? Clouds.SKC
        
        if let precipitation = forecast.precipitation {
            let weatherIconOptions = WeatherImageGenerator.generateWeatherIcon(base: precipitation[0].icon,
                                                                               sunAndCloud: precipitation[0].modifiers,
                                                                               cloudCoverage: clouds,
                                                                               night: forecast.night)
            self.weatherIcon = weatherIconOptions.weatherIcon
            self.weatherIconColors = weatherIconOptions.colors
        } else {
            self.weatherIcon = clouds.cloudImage(night: forecast.night)
            self.weatherIconColors = [.primary, .primary, .primary]
        }
        self.forecast = forecast
        
    }
    
}


