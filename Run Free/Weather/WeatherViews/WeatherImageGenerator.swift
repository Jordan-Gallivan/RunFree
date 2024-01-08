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
    
    /// Generates the SF Image for the provided SF Image suffix and cloud/sun prefix categories.
    ///
    /// - Parameters:
    ///    - sfImageSuffix: SF Image suffix to for weather condition.
    ///    - sunAndCloud: SF Image suffix for cloud/sun categories.
    ///    - cloudCoverage: Cloud Coverage amount (example .OVC).
    ///    - night: True weater Icon is for a period at night.
    ///
    ///  - Returns: An WeatherImage struct contatining the image associated with the weather condition as well as the colors for rendering in both light and dark mode.
    static func generateWeatherIcon(sfImageSuffix: String, sunAndCloud: SystemNameSunAndCloud, cloudCoverage: Clouds, night: Bool) -> WeatherImage {
        var prefix = WeatherConditionConstants.CLOUD_PREFIX

        switch sunAndCloud {
        case .none:
            prefix = ""
        case .cloudAndSun:
            if cloudCoverage < Clouds.BKN {
                prefix = night ? WeatherConditionConstants.CLOUD_AND_MOON_PREFIX : WeatherConditionConstants.CLOUD_AND_SUN_PREFIX
            }
        case .cloudOrSun:
            if cloudCoverage <= Clouds.SCT && !night {
                prefix = WeatherConditionConstants.SUN_PREFIX
            } else {
                prefix = WeatherConditionConstants.CLOUD_PREFIX
            }
        case .sun:
            prefix = night ? WeatherConditionConstants.MOON_PREFIX : WeatherConditionConstants.SUN_PREFIX
        default:
            break
        }
        let colors = WeatherIconColor(prefix: prefix, suffix: sfImageSuffix)
        
        return WeatherImage(
            image: sfImageSuffix.contains("custom") ? Image(prefix + sfImageSuffix) : Image(systemName: prefix + sfImageSuffix),
            lightModeColors: colors,
            darkModeColors: colors
        )
            
    }
    
    /// Returns the colors for rendering the SF image with the prefix and suffix provided.
    private static func WeatherIconColor(prefix: String, suffix: String) -> [Color] {
        switch suffix {
        case "rain":
            switch prefix {
            case WeatherConditionConstants.SUN_PREFIX:
                return [.blue, .yellow, . primary]
            case WeatherConditionConstants.MOON_PREFIX:
                return [.blue, .gray, .primary]
            case WeatherConditionConstants.CLOUD_AND_SUN_PREFIX:
                return [.primary, .yellow, .blue]
            case WeatherConditionConstants.CLOUD_AND_MOON_PREFIX:
                return [.primary, .gray, .blue]
            default:
                return [.primary, .blue, .primary]
            }
        case "snow":
            switch prefix {
            case WeatherConditionConstants.SUN_PREFIX:
                return [.cyan, .yellow, .primary]
            case WeatherConditionConstants.MOON_PREFIX:
                return [.cyan, .gray, .primary]
            default:
                return [.primary, .cyan, .primary]
            }
        case "sleet.custom":
            return [.primary, .blue, .cyan]
        case "hail":
            return [.primary, .cyan, .primary]
        case "heavyrain":
            return [.primary, .blue, .primary]
        case "fog":
            return [.primary, .gray, .primary]
        case "dust":
            return prefix == WeatherConditionConstants.SUN_PREFIX ? [.brown, .yellow, .primary] : [.brown, .gray, .primary]
        case "haze":
            return prefix == WeatherConditionConstants.SUN_PREFIX ? [.gray, .yellow, .primary] : [.gray, .gray, .primary]
        case "bolt.rain.custom":
            return [.primary, .yellow, .blue]
        case "bolt.custom":
            if prefix == WeatherConditionConstants.CLOUD_PREFIX {
                return [.primary, .yellow, .primary]
            } else if prefix == WeatherConditionConstants.CLOUD_AND_SUN_PREFIX {
                return [.primary, .yellow, .yellow]
            } else {
                return [.primary, .gray, .yellow]
            }
        default:
            return [.primary, .primary, .primary]
        }
    }
    
    /// Generates a WeatherImage Struct containing the SF Image for the given temperature as well as the colors for rendering in both light and dark mode.
    ///
    ///
    /// - Parameter temp: Temperature in degrees celsius.
    ///
    /// - Returns: WeatherImage Struct containing the SF Image for the given temperature as well as the colors for rendering in both light and dark mode.
    ///
    /// Example:
    ///  * 38+                                      : Very Hot - red thermomer with sun
    ///  * 32 <= temp < 38      : Hot  - orange thermometer with sun
    ///  * 26 <= temp < 32      : Warm - yellow thermometer with sun
    ///  * 10 <= temp < 26      : Normal - red thermometer
    ///  * 5 <= temp < 10       : Cold - cyan thermometer
    ///  * < 5                  : Very Cold - cyan thermometer with snowflake
    static func generateTemperatureIcon(temp: Int) -> WeatherImage {
        switch temp {
        case 38...1000:
            return WeatherImage(
                image: Image(systemName: "thermometer.sun.fill").symbolRenderingMode(.palette),
                lightModeColors: [.red, .yellow, .red],
                darkModeColors: [.red, .yellow, .red])
        case 32..<38:
            return WeatherImage(
                image: Image(systemName: "thermometer.sun.fill").symbolRenderingMode(.palette),
                lightModeColors: [.red, .yellow, .orange],
                darkModeColors: [.red, .yellow, .orange])
        case 26..<32:
            return WeatherImage(
                image: Image(systemName: "thermometer.high").symbolRenderingMode(.palette),
                lightModeColors: [.red, .black, .gray],
                darkModeColors: [.red, .white, .white])
        case 10..<26:
            return WeatherImage(
                image: Image(systemName: "thermometer.medium").symbolRenderingMode(.palette),
                lightModeColors: [.red, .black, .gray],
                darkModeColors: [.red, .white, .white])
        case 5..<10:
            return WeatherImage(
                image: Image(systemName: "thermometer.low").symbolRenderingMode(.palette),
                lightModeColors: [.cyan, .black, .gray],
                darkModeColors: [.cyan, .white, .white])
        default:
            return WeatherImage(
                image: Image(systemName: "thermometer.snowflake").symbolRenderingMode(.palette),
                lightModeColors: [.cyan, .cyan, .gray],
                darkModeColors: [.cyan, .white, .white])
        }
        
    }
    
    static func generateSunriseSunsetImage(sunrise: Bool = false, sunset: Bool = false, colorScheme: ColorScheme) -> WeatherImage {
        if sunrise {
            return WeatherImage(image: Image(systemName: "sunrise.fill").symbolRenderingMode(.palette),
                                lightModeColors: [.primary, .yellow, .primary],
                                darkModeColors: [.primary, .yellow, .primary]
            )
        }
        return WeatherImage(image: Image(systemName: "sunset.fill").symbolRenderingMode(.palette),
                            lightModeColors: [.primary, .yellow, .primary],
                            darkModeColors: [.primary, .yellow, .primary]
        )
    }
    
}
