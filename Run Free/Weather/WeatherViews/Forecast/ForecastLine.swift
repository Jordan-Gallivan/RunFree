//
//  ForecastLine.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/17/23.
//

import Foundation
import SwiftData
import SwiftUI

/// Single line of forecast.  Two viewing options: normal and expanded.  In expaned view, all weather condition lines are displayed as well as wind information.
struct ForecastLine: View {
    @EnvironmentObject private var appData: AppData
    @Environment(\.modelContext) var dbContext
    @Environment(\.colorScheme) var colorScheme
    // Query Settings Model.  Only one model in context, ensured at application initialization
    @Query private var settingsQuery: [SettingsModel]
    private var settings: SettingsModel { settingsQuery.first! }
    
    var forecast: Forecast
    var weatherImage: WeatherImage
    var windIcon: Image? = nil
    var probability: Text? = nil
    var backgroundColor: Color
    var expandedView: Bool
    
    var forecastTimeFormat: DateFormatter {
        let formatter = DateFormatter()
        if settings.twelveHourClock {
            formatter.dateFormat = "h:mm a"
            return formatter
        } else {
            formatter.dateFormat = "HH:mm"
            return formatter
        }
    }
    
    var body: some View {
        HStack {
            // Time
            Text(self.forecastTimeFormat.string(from: self.forecast.dateObject))
                .font(.title2)
            Spacer()
            
            // Wind
            if self.expandedView,
               let windDirection = forecast.windDirection,
               let windSpeed = forecast.convertedWindSpeed(isMetric: settings.metric) {
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
                        Text("\(windSpeed)\(settings.metric ? "kph" : "mph")")
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
                if let weatherCondition = forecast.weatherCondition {
                    if self.expandedView {
                        VStack {
                            ForEach(weatherCondition) { wxCondition in
                                Text(wxCondition.description)
                                    .font(.footnote)
                            }
                        }
                    } else {
                        Text(weatherCondition[0].description)
                            // TODO: size text to fit
                    }
                    Spacer()
                } else if let clouds = forecast.clouds {
                    Text(clouds.cloudString())
                    Spacer()
                }
                
            }
            
            // Weather Image
            if colorScheme == .dark {
                weatherImage.image
                    .font(.title2)
                    .foregroundStyle(weatherImage.darkModeColors[0], weatherImage.darkModeColors[1], weatherImage.darkModeColors[2])
            } else {
                weatherImage.image
                    .font(.title2)
                    .foregroundStyle(weatherImage.lightModeColors[0], weatherImage.lightModeColors[1], weatherImage.lightModeColors[2])
            }
            
        }
        .padding([.horizontal], 10)
        .padding([.vertical], 7)
        .background(self.backgroundColor)
        .frame(maxWidth: .infinity)
    }
    
    init(forecast: Forecast, colorScheme: ColorScheme, expandedView: Bool = false) {
        self.expandedView = expandedView
        self.backgroundColor = forecast.backgroundColor
        
        // determine if a sunrise/sunset line
        if forecast.sunrise {
            self.weatherImage = WeatherImageGenerator.generateSunriseSunsetImage(sunrise: true, colorScheme: colorScheme)
            self.forecast = forecast
            return
        } else if forecast.sunset {
            self.weatherImage = WeatherImageGenerator.generateSunriseSunsetImage(sunset: true, colorScheme: colorScheme)
            self.forecast = forecast
            return
        }
        
        // determine if wind is strong enough to include "windy" image
        if forecast.windIcon {
            self.windIcon = WeatherImageGenerator.windIcon
        }
        
        if let prob = forecast.probability {
            self.probability = Text(String(prob) + "%")
        }
        
        let clouds = forecast.clouds ?? Clouds.SKC
        
        // parse precipitation or display current cloud conditions
        if let weatherCondition = forecast.weatherCondition {
            self.weatherImage = WeatherImageGenerator.generateWeatherIcon(sfImageSuffix: weatherCondition[0].sfImageSuffix,
                                                                               sunAndCloud: weatherCondition[0].modifiers,
                                                                               cloudCoverage: clouds,
                                                                               night: forecast.night)
        } else {
            self.weatherImage = clouds.cloudImage(night: forecast.night)
        }
        self.forecast = forecast
    }
    
}


