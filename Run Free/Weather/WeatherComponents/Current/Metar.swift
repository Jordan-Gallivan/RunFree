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
    var precipitation: [Precipitation]? = nil
    var clouds: Clouds = .SKC
    private var tempMetric = 0
    var night: Bool
    
    func windSpeed(metric: Bool) -> Int {
        return metric
        ? Int(Double(self.windSpeedKnots) * 1.852)
        : Int(Double(self.windSpeedKnots) * 1.15078)
    }
    func temperature(metric: Bool) -> String {
        let adjustedTemp = metric
        ? tempMetric
        : (tempMetric * 9) / 5 + 32
        let units = metric ? "°C" : "°F"
        
        return "\(adjustedTemp)\(units)"
    }
    var windIcon: Bool {
        get {
            return windSpeedKnots >= 20
        }
    }
    
    var temperatureIcon: TemperatureIconOptions {
        get {
            return WeatherImageGenerator.generateTemperatureIcon(temp: tempMetric)
        }
    }
    func windString(metric: Bool) -> String {
        let units = metric ? "kph" : "mph"
        return "\(windDirection) at \(windSpeed(metric: metric))\(units)"
    }
    
        
    required init(weatherString: String, night: Bool) throws {
        self.night = night
        try updateMetar(metar: weatherString)
    }
    
    /// Updates the weather data for a new METAR
    ///
    /// - Parameter metar: METAR String for updated weather.
    ///     example: "METAR KTTN 051853Z 11011KT 1/2SM VCTS SN FZFG BKN003 OVC010 M02/M02 A3006 RMK AO2 TSB40 SLP176 P0002 T10171017"
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
                
        let (precipitation, windDirection, windSpeed, clouds, temperature) = WeatherParser.parseWeather(
            weather:Array(components[j..<components.count]),
            metar: true)
        
        guard let windDirection, let windSpeed, let clouds, let temperature else {
            var errorMessage = "Error "
            if windDirection == nil || windSpeed == nil {
                errorMessage += "parsing wind, "
            }
            if clouds == nil {
                errorMessage += "parsing clouds, "
            }
            if temperature == nil {
                errorMessage += "parsing temperature, "
            }
            errorMessage = String(errorMessage[errorMessage.startIndex..<errorMessage.index(errorMessage.endIndex, offsetBy: -2)])
            
            throw MetarError.runTimeError(message: errorMessage)
        }
        
        self.precipitation = precipitation
        self.windDirection = windDirection
        self.windSpeedKnots = windSpeed
        self.clouds = clouds
        self.tempMetric = temperature
        
    }
    
    enum MetarError: Error {
        case runTimeError(message: String)
    }

}
