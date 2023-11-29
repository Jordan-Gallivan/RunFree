//
//  CurrentWeatherView.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/22/23.
//

import Foundation
import SwiftUI

struct CurrentWeatherView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appData: AppData
    
    let metar: Metar
    var temperatureIcon: Image
    var temperatureIconColors: [Color]
    var windIcon: Image = WeatherImageGenerator.windIcon
    var weatherIcon: Image
    var weatherIconColors: [Color]
    var weatherArray: [Precipitation]
    
    @ViewBuilder
    var temperature: some View {
        HStack{
            Text(String(metar.temperature(metric: appData.metric)))
            temperatureIcon
                .foregroundStyle(temperatureIconColors[0], temperatureIconColors[1], temperatureIconColors[2])
        }
    }
    
    @ViewBuilder
    var wind: some View {
        HStack{
            windIcon
            Text(metar.windString(metric: appData.metric))
        }
    }
    
    @ViewBuilder
    var weather: some View {
        VStack(spacing: 5) {
            weatherIcon
                .imageScale(.large)
                .font(.largeTitle)
                .foregroundStyle(self.weatherIconColors[0], self.weatherIconColors[1], self.weatherIconColors[2])
            VStack {
                ForEach(weatherArray, id: \.self) { wx in
                    Text(wx.description)
                        .lineLimit(1)
                        .scaledToFit()
                        .minimumScaleFactor(0.5)
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
        
        let temperatureIconOptions = metar.temperatureIcon
        self.temperatureIcon = temperatureIconOptions.image
        
        self.temperatureIconColors = colorScheme == .dark
                                        ? temperatureIconOptions.darkModeColors
                                        : temperatureIconOptions.lightModeColors

//        self.windIcon = metar.windIcon ? WeatherImageGenerator.windIcon : nil
        if let precipitation = metar.precipitation {
            let weatherIconOptions = WeatherImageGenerator.generateWeatherIcon(base: precipitation[0].icon,
                                                                         sunAndCloud: precipitation[0].modifiers,
                                                                         cloudCoverage: metar.clouds,
                                                                         night: metar.night)
            self.weatherIcon = weatherIconOptions.weatherIcon
            self.weatherIconColors = weatherIconOptions.colors
            self.weatherArray = precipitation
        } else {
            self.weatherIcon = metar.clouds.cloudImage(night: metar.night)
            self.weatherIconColors = [.primary, .primary, .primary]
            self.weatherArray = []
        }
    }
    
}
