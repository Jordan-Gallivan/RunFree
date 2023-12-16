//
//  Weather.swift
//  Run Free
//
//  Created by Jordan Gallivan on 9/21/23.
//

import Foundation

/// Static class to parse components of a METAR or TAF
enum WeatherParser {
    
    /// Parses a line from a METAR or TAF into its requisite components.
    ///
    /// - Parameters:
    ///    - weather: Array of string values that make up the METAR or TAF line.
    ///    - metar: True if weather line is from a METAR.
    ///
    /// - Returns: a ParsedWeather Struct containing the parsed components of the weather line.
    static func parseWeather(weather: String) -> ParsedWeather {
        var weatherCondition: [WeatherCondition]? = nil
        var windDirection: String? = nil
        var windSpeed: Int? = nil
        var clouds: Clouds? = nil
        var temperature: Int? = nil
        
        let weatherConditionMatches = weather.matches(of: WeatherParserRegEx.WEATHER_CONDITIONS).map { $0.1 }
        let windMatches = weather.matches(of: WeatherParserRegEx.WIND).map { $0.1 }
        let cloudMatches = weather.matches(of: WeatherParserRegEx.CLOUDS).map { $0.1 }
        let temperatureMatches = weather.matches(of: WeatherParserRegEx.TEMPERATURE).map { $0.1 }
        
        // parse wind
        if !windMatches.isEmpty {
            (windDirection, windSpeed) = parseWind(wind: String(windMatches[0]))
        }
        
        // parse weather conditions
        if !weatherConditionMatches.isEmpty {
            weatherCondition = parseWeatherCondition(weatherCondition: weatherConditionMatches.map { String($0) })
        }
        
        // parse clouds
        if !cloudMatches.isEmpty {
            clouds = parseClouds(cloudConditions: cloudMatches.map { String($0) })
        }
        
        // parse temperature
        if !temperatureMatches.isEmpty {
            temperature = parseTemperature(temperatureString: String(temperatureMatches[0]))
        }
        
        return ParsedWeather(weatherCondition: weatherCondition,
                             windDirection: windDirection,
                             windSpeed: windSpeed,
                             clouds: clouds,
                             temperature: temperature)
    }
    
    /// Calculates the wind direction and speed.
    ///
    /// - Parameter wind: String containing both the wind direciton and speed.  Example "04015KT".
    /// - Returns: (Wind Direction, Wind Speed).
    private static func parseWind(wind: String) -> (String, Int) {
        let windDirInt = Int(wind[..<wind.index(wind.startIndex, offsetBy: 3)]) ?? -1
        let windSpeed = Int(wind[wind.index(wind.startIndex, offsetBy: 3)..<wind.index(wind.startIndex, offsetBy: 5)]) ?? 0
        var windDirStr = ""

        switch (windDirInt) {
        case 0..<23:
            windDirStr = "North"
        case 23..<67:
            windDirStr = "North East"
        case 67..<113:
            windDirStr = "East"
        case 113..<157:
            windDirStr = "South East"
        case 157..<203:
            windDirStr = "South"
        case 203..<247:
            windDirStr = "South West"
        case 247..<293:
            windDirStr = "West"
        case 293..<337:
            windDirStr = "North West"
        case -1:
            windDirStr = "Variable"
        default:
            windDirStr = "North"
        }
        return (windDirStr, windSpeed)
    }
    
    /// Calculates the current weather condition as an array of strings.
    ///
    /// - Parameter precipitation: An array of precipitation strings to be parsed.  Example: ["VCTS", "SN", "FZFG"].
    /// - Returns: A WeatherCondition Struct containing the name, SF Image prefix, and associate cloud/sun modifiers.
    private static func parseWeatherCondition(weatherCondition: [String]) -> [WeatherCondition]? {
        
        guard weatherCondition.count > 0 else {
            return nil
        }
        var returnArray: [WeatherCondition] = []
        
        for precip in weatherCondition{
            var intensity = ""
            var i = precip.startIndex
            
            // annotate heave or light modifiers (+ or - before weather condition)
            switch precip[i] {
            case "+":
                intensity += "Heavy "
                i = precip.index(i, offsetBy: 1)
            case "-":
                intensity += "Light "
                i = precip.index(i, offsetBy: 1)
            default:
                break
            }
            
            guard var currPrecip = WeatherConditionConstants.WEATHER_CONDITION_DICTIONARY[String(precip[i..<precip.endIndex])] else {
                continue
            }
            
            currPrecip.description = intensity + currPrecip.description
            returnArray.append(currPrecip)
            
        }
        
        
        
        return returnArray
    }
    
    /// Calculates the current prevailing cloud condition
    ///
    /// - Parameter cloudConditions: An array of cound conditions.  Example: ["BKN003", "OVC010"]
    /// - Returns the prevailing cloud condition.
    private static func parseClouds<T: Sequence>(cloudConditions: T) -> Clouds where T.Iterator.Element == String {
        var predomCloud = Clouds.SKC
        
        for cloudCondition in cloudConditions {
            var currCloud: Clouds
            
            switch (cloudCondition[
                cloudCondition.startIndex..<cloudCondition.index(cloudCondition.startIndex, offsetBy: 3)]) {
            case Clouds.OVC.rawValue:
                currCloud = Clouds.OVC
            case Clouds.BKN.rawValue:
                currCloud = Clouds.BKN
            case Clouds.SCT.rawValue:
                currCloud = Clouds.SCT
            case Clouds.FEW.rawValue:
                currCloud = Clouds.FEW
            default:
                continue
            }
            predomCloud = max(predomCloud, currCloud)
        }
        
        return predomCloud
    }
    
    /// Calculates the current temperature in degrees celsius.
    ///
    /// - Parameter tempString: Current Temperature/DewPoint string.  Example: M02/M02.
    /// - Returns current temperature in degrees celsius.
    private static func parseTemperature(temperatureString tempString: String) -> Int {
        var minusMultiplier = 1
        
        var start = tempString.startIndex
        if tempString[start] == "M" {
            minusMultiplier = -1
            start = tempString.index(start, offsetBy: 1)
        }
        let end = tempString.firstIndex(of: "/") ?? tempString.index(start, offsetBy: 2)
        
        return minusMultiplier * (Int(tempString[start..<end]) ?? 0)
    }
}
