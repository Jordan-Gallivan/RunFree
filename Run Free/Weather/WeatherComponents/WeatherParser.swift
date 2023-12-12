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
    /// - Returns: (weatherCondition, windDirection, windSpeed, clouds, temperature).  Note all return values are optional.
    static func parseWeather(weather: [String], isMetar: Bool = false) -> ([WeatherCondition]?, String?, Int?, Clouds?, Int?) {
        
        var j = 0
        var weatherCondition: [WeatherCondition]? = nil
        var windDirection: String? = nil
        var windSpeed: Int? = nil
        var clouds: Clouds? = nil
        var temperature: Int? = nil
        
        // determine if wind is in string and update (string ends in "KT")
        if weather[j].firstMatch(of: /KT$/) != nil {
            (windDirection, windSpeed) = parseWind(wind: weather[j])
            j += 1
        }
        // skip over variable wind
        if weather[j].firstMatch(of: /\d{3}V\d{3}/) != nil {
            j += 1
        }
        
        // skip over visibility (string is either 4 digits or ends in "SM")
        while j < weather.count && (weather[j].firstMatch(of: /\d{4}/) != nil || weather[j].firstMatch(of: /SM$/) != nil || weather[j].count < 2) {
            j += 1
        }
        
        // parse weather conditions
        var k = j
        while k < weather.count {
            let entry = weather[k]
            if SKY_CONDITIONS.contains(String(entry[..<entry.index(entry.startIndex, offsetBy:2)])) {
                break
            }
            if entry.count > 2 && SKY_CONDITIONS.contains(String(entry[..<entry.index(entry.startIndex, offsetBy:3)])) {
                break
            }
            k += 1
        }
        if k != j {
            weatherCondition = parseWeatherCondition(weatherCondition: weather[j..<k].map {String($0)})
        }
        j = k
        
        // parse wind
        while k < weather.count {
            let entry = weather[k]
            let firstTwo = SKY_CONDITIONS.contains(String(entry[..<entry.index(entry.startIndex, offsetBy:2)]))
            let firstThree = entry.count > 2 && SKY_CONDITIONS.contains(String(entry[..<entry.index(entry.startIndex, offsetBy:3)]))
            if !firstTwo && !firstThree {
                break
            }
            k += 1
        }
        
        if k != j {
            clouds = parseClouds(cloudConditions: weather[j..<k])
        }
        
        // parse temperature if a METAR
        if isMetar {
            while k < weather.count {
                let entry = weather[k]
                if entry.contains("/") {
                    break
                }
                k += 1
            }
            
            temperature = k < weather.count
                            ? parseTemperature(temperatureString: weather[k])
                            : nil
        }
        
        return (weatherCondition, windDirection, windSpeed, clouds, temperature)
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
