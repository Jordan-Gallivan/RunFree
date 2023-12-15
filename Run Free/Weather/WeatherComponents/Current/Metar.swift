//
//  Metar.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/3/23.
//

import Foundation
import SwiftUI

/// Parses and Stores the Weather information for a Meteorological Aerodrome Report (METAR).
class Metar {

    var windDirection = ""
    private var windSpeedKnots = 0
    var precipitation: [WeatherCondition]? = nil
    var clouds: Clouds = .SKC
    private var tempMetric = 0
    var night: Bool
    var windIcon: Bool { windSpeedKnots >= 20 }
    var temperatureIcon: WeatherImage { WeatherImageGenerator.generateTemperatureIcon(temp: tempMetric) }
    
    
    
        
    required init(weatherString: String, night: Bool) throws {
        self.night = night
        try updateMetar(metar: weatherString)
    }
    
    // MARK: - Metric dependent properties
        func windString(metric: Bool) -> String {
        let units = metric ? "kph" : "mph"
        return "\(windDirection) at \(windSpeed(isMetric: metric))\(units)"
    }
    func windSpeed(isMetric: Bool) -> Int {
        return isMetric
        ? Int(Double(self.windSpeedKnots) * 1.852)
        : Int(Double(self.windSpeedKnots) * 1.15078)
    }
    func temperature(isMetric: Bool) -> String {
        let adjustedTemp = isMetric
        ? tempMetric
        : (tempMetric * 9) / 5 + 32
        let units = isMetric ? "°C" : "°F"
        
        return "\(adjustedTemp)\(units)"
    }
    
    
    /// Updates the weather data for a new METAR
    ///
    /// - Parameter metar: METAR String for updated weather.
    ///     Example: "METAR KTTN 051853Z 11011KT 1/2SM VCTS SN FZFG BKN003 OVC010 M02/M02 A3006 RMK AO2 TSB40 SLP176 P0002 T10171017"
    public func updateMetar(metar: String) throws {
        let components = metar.split(separator: " ").map { String($0) }
        
        // trucate metar
        var j = 0
        while j < components.count && components[j].firstMatch(of: /KT$/) == nil {
            j += 1
        }
        guard j < components.count else {
            throw MetarError.runTimeError(message: "INVALID METAR")
        }
                
        let parsedWeather = WeatherParser.parseWeather(weather: metar)
        
        guard let windDirection = parsedWeather.windDirection,
                let windSpeed = parsedWeather.windSpeed,
                let clouds = parsedWeather.clouds,
                let temperature = parsedWeather.temperature else {
            var errorMessage = "Error "
            if parsedWeather.windDirection == nil || parsedWeather.windSpeed == nil {
                errorMessage += "parsing wind, "
            }
            if parsedWeather.clouds == nil {
                errorMessage += "parsing clouds, "
            }
            if parsedWeather.temperature == nil {
                errorMessage += "parsing temperature, "
            }
            errorMessage = String(errorMessage[errorMessage.startIndex..<errorMessage.index(errorMessage.endIndex, offsetBy: -2)])
            
            throw MetarError.runTimeError(message: errorMessage)
        }
        
        self.precipitation = parsedWeather.weatherCondition
        self.windDirection = windDirection
        self.windSpeedKnots = windSpeed
        self.clouds = clouds
        self.tempMetric = temperature
        
    }
    
    enum MetarError: Error {
        case runTimeError(message: String)
    }

}
