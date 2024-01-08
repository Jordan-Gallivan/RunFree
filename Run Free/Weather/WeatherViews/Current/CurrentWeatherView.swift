//
//  CurrentWeatherView.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/22/23.
//

import Foundation
import SwiftData
import SwiftUI

/// Displays the current weather from provided METAR.
struct CurrentWeatherView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appData: AppData
    // Query Settings Model.  Only one model in context, ensured at application initialization
    @Environment(\.modelContext) var dbContext
    @Query private var settingsQuery: [SettingsModel]
    private var settings: SettingsModel { settingsQuery.first! }
    
    let metar: Metar
    var temperatureImage: WeatherImage
    var windImage: Image = WeatherImageGenerator.windIcon
    var weatherImage: WeatherImage
    var weatherArray: [WeatherCondition]
    
    @ViewBuilder
    var temperature: some View {
        HStack{
            Text(String(metar.temperature(isMetric: settings.metric)))
            if colorScheme == .dark {
                temperatureImage.image
                    .foregroundStyle(temperatureImage.darkModeColors[0], temperatureImage.darkModeColors[1], temperatureImage.darkModeColors[2])
            } else {
                temperatureImage.image
                    .foregroundStyle(temperatureImage.lightModeColors[0], temperatureImage.lightModeColors[1], temperatureImage.lightModeColors[2])
            }
        }
    }
    
    @ViewBuilder
    var wind: some View {
        HStack{
            windImage
            Text(metar.windString(metric: settings.metric))
        }
    }
    
    @ViewBuilder
    var weather: some View {
        VStack(spacing: 5) {
            if colorScheme == .dark {
                weatherImage.image
                    .imageScale(.large)
                    .font(.largeTitle)
                    .foregroundStyle(weatherImage.darkModeColors[0], weatherImage.darkModeColors[1], weatherImage.darkModeColors[2])
            } else {
                weatherImage.image
                    .imageScale(.large)
                    .font(.largeTitle)
                    .foregroundStyle(weatherImage.lightModeColors[0], weatherImage.lightModeColors[1], weatherImage.lightModeColors[2])
            }
            VStack {
                if weatherArray.count > 0 {
                    ForEach(weatherArray, id: \.self) { wx in
                        Text(wx.description)
                            .lineLimit(1)
                            .scaledToFit()
                            .minimumScaleFactor(0.5)
                    }
                } else {
                    Text(metar.clouds.cloudString())
                }
                
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 5){
            VStack(spacing: 10){
                temperature.font(.largeTitle.weight(.semibold))
                wind
            }.frame(minWidth: 0, maxWidth: .infinity)
            weather
                .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
    
    init(metar: Metar, colorScheme: ColorScheme) {
        self.metar = metar
        
        self.temperatureImage = metar.temperatureIcon
        
        if let precipitation = metar.precipitation {
            self.weatherImage = WeatherImageGenerator.generateWeatherIcon(sfImageSuffix: precipitation[0].sfImageSuffix,
                                                                         sunAndCloud: precipitation[0].modifiers,
                                                                         cloudCoverage: metar.clouds,
                                                                         night: metar.night)
            self.weatherArray = precipitation
        } else {
            self.weatherImage = metar.clouds.cloudImage(night: metar.night)
            self.weatherArray = []
        }
    }
    
}
