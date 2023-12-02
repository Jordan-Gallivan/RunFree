//
//  WeatherImageGenerator.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/19/23.
//

import Foundation
import SwiftUI

final class WeatherImageGenerator {
    
    static let windIcon = Image(systemName: "wind")
    
    static func generateWeatherIcon(base: String, sunAndCloud: SystemNameSunAndCloud, cloudCoverage: Clouds, night: Bool) -> PrecipitationOptions {
        var prefix = PrecipitationConstants.CLOUD_PREFIX

        switch sunAndCloud {
        case .none:
            prefix = ""
        case .cloudAndSun:
            if cloudCoverage < Clouds.BKN {
                prefix = night ? PrecipitationConstants.CLOUD_AND_MOON_PREFIX : PrecipitationConstants.CLOUD_AND_SUN_PREFIX
            }
        case .cloudOrSun:
            if cloudCoverage <= Clouds.SCT && !night {
                prefix = PrecipitationConstants.SUN_PREFIX
            } else {
                prefix = PrecipitationConstants.CLOUD_PREFIX
            }
        case .sun:
            prefix = night ? PrecipitationConstants.MOON_PREFIX : PrecipitationConstants.SUN_PREFIX
        default:
            break
        }
        return PrecipitationOptions(
            weatherIcon: base.contains("custom") ? Image(prefix + base) : Image(systemName: prefix + base),
            colors: WeatherIconColor(prefix: prefix, base: base))
    }
    
    private static func WeatherIconColor(prefix: String, base: String) -> [Color] {
        switch base {
        case "rain":
            switch prefix {
            case PrecipitationConstants.SUN_PREFIX:
                return [.blue, .yellow, . primary]
            case PrecipitationConstants.MOON_PREFIX:
                return [.blue, .gray, .primary]
            case PrecipitationConstants.CLOUD_AND_SUN_PREFIX:
                return [.primary, .yellow, .blue]
            case PrecipitationConstants.CLOUD_AND_MOON_PREFIX:
                return [.primary, .gray, .blue]
            default:
                return [.primary, .blue, .primary]
            }
        case "snow":
            switch prefix {
            case PrecipitationConstants.SUN_PREFIX:
                return [.cyan, .yellow, .primary]
            case PrecipitationConstants.MOON_PREFIX:
                return [.cyan, .gray, .primary]
            default:
                return [.primary, .cyan, .primary]
            }
        case "hail":
            return [.primary, .cyan, .primary]
        case "heavyrain":
            return [.primary, .blue, .primary]
        case "fog":
            return [.primary, .gray, .primary]
        case "dust":
            return prefix == PrecipitationConstants.SUN_PREFIX ? [.brown, .yellow, .primary] : [.brown, .gray, .primary]
        case "haze":
            return prefix == PrecipitationConstants.SUN_PREFIX ? [.gray, .yellow, .primary] : [.gray, .gray, .primary]
        case "bolt.rain.custom":
            return [.primary, .yellow, .blue]
        case "bolt.custom":
            if prefix == PrecipitationConstants.CLOUD_PREFIX {
                return [.primary, .yellow, .primary]
            } else if prefix == PrecipitationConstants.CLOUD_AND_SUN_PREFIX {
                return [.primary, .yellow, .yellow]
            } else {
                return [.primary, .gray, .yellow]
            }
        default:
            return [.primary, .primary, .primary]
        }
    }
    
    static func generateTemperatureIcon(temp: Int) -> TemperatureIconOptions {
        /*
         100+   -> Very Hot - red thermomer with sun
         90+    -> Hot  - orange thermometer with sun
         80+    -> Warm - yellow thermometer with sun
         
         <40    -> Cold -
         <30    -> Very Cold
         <20    -> Freezing
         */
        
        switch temp {
        case 38...1000:
            return TemperatureIconOptions(
                image: Image(systemName: "thermometer.sun.fill").symbolRenderingMode(.palette),
                lightModeColors: [.red, .yellow, .red],
                darkModeColors: [.red, .yellow, .red])
        case 32..<38:
            return TemperatureIconOptions(
                image: Image(systemName: "thermometer.sun.fill").symbolRenderingMode(.palette),
                lightModeColors: [.red, .yellow, .orange],
                darkModeColors: [.red, .yellow, .orange])
        case 26..<32:
            return TemperatureIconOptions(
                image: Image(systemName: "thermometer.high").symbolRenderingMode(.palette),
                lightModeColors: [.red, .black, .gray],
                darkModeColors: [.red, .white, .white])
        case 10..<26:
            return TemperatureIconOptions(
                image: Image(systemName: "thermometer.medium").symbolRenderingMode(.palette),
                lightModeColors: [.red, .black, .gray],
                darkModeColors: [.red, .white, .white])
        case 5..<10:
            return TemperatureIconOptions(
                image: Image(systemName: "thermometer.low").symbolRenderingMode(.palette),
                lightModeColors: [.cyan, .black, .gray],
                darkModeColors: [.cyan, .white, .white])
        default:
            return TemperatureIconOptions(
                image: Image(systemName: "thermometer.snowflake").symbolRenderingMode(.palette),
                lightModeColors: [.cyan, .cyan, .gray],
                darkModeColors: [.cyan, .white, .white])
        }
        
    }
    
    static func generateSunriseSunsetImage(sunrise: Bool = false, sunset: Bool = false, colorScheme: ColorScheme) -> Image {
        if sunrise {
            return Image(systemName: "sunrise.fill").symbolRenderingMode(.palette)
        }
        return Image(systemName: "sunset.fill").symbolRenderingMode(.palette)
    }
    
}
