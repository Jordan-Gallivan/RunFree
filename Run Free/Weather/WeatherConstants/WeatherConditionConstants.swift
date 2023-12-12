//
//  PrecipitationConstants.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/26/23.
//

import Foundation
import SwiftUI


enum WeatherConditionConstants {
    
    /// Dictionary of weather condition identifier matchecd with Precipitation Object containing: name, SF Image suffix, and cloud/sun prefix matching
    ///
    /// Example: "RA": Precipitation("Rain", "rain", .cloudAndSun)
    static let WEATHER_CONDITION_DICTIONARY: [String : WeatherCondition] = [
        "DZ": WeatherCondition("Drizzile", "rain", .cloudAndSun),
        "RA": WeatherCondition("Rain", "rain", .cloudAndSun),
        "SN": WeatherCondition("Snow", "snow", .cloud),
        "SG": WeatherCondition("Snow Grains", "snow", .cloudOrSun),
        "IC": WeatherCondition("Ice Crystals", "snow", .cloudOrSun),
        "PL": WeatherCondition("Ice Pelelts", "snow", .cloudOrSun),
        "GR": WeatherCondition("Hail", "hail", .cloud),
        "GS": WeatherCondition("Small Hail", "hail", .cloud),
        "TS": WeatherCondition("Thunderstorm", "bolt.custom", .cloudAndSun),
        "VCTS": WeatherCondition("Thunderstorm", "bolt.custom", .cloudAndSun),
        "TSRA": WeatherCondition("Thunderstorm and Rain", "bolt.rain.custom", .cloud),
        "TSSN": WeatherCondition("Thunderstorm and Snow", "bolt.custom", .cloud),
        "TSPL": WeatherCondition("Thunderstorm and Ice Pellets", "bolt.custom", .cloud),
        "TSGS": WeatherCondition("Thunderstorm and Snow Grains", "bolt.custom", .cloud),
        "TSGR": WeatherCondition("Thunderstorm and Hail", "bolt.custom", .cloud),
        "SH": WeatherCondition("Showers", "rain", .cloudAndSun),
        "VCSH": WeatherCondition("Showers", "heavyrain", .cloud),
        "SHRA": WeatherCondition("Rain Showers", "heavyrain", .cloud),
        "SHSN": WeatherCondition("Snow Showers", "snow", .cloudOrSun),
        "SHPL": WeatherCondition("Showers of Ice Pellets", "snow", .cloudOrSun),
        "SHGR": WeatherCondition("Hail Showers", "hail", .cloud),
        "SHGS": WeatherCondition("Small Hail Showers", "hail", .cloud),
        "FZDZ": WeatherCondition("Freezing Drizzle", "snow", .cloudOrSun),
        "FZRA": WeatherCondition("Freezing Rain", "rain", .cloudAndSun),    // TODO: potentially change to rain
        "FZFG": WeatherCondition("Freezing Drizzle", "fog", .cloud),
        "BR": WeatherCondition("Mist", "fog", .cloud),
        "FG": WeatherCondition("Fog", "fog", .cloud),
        "FU": WeatherCondition("Smoke", "fog", .cloud),
        "VA": WeatherCondition("Volcanic Ash", "fog", .cloud),
        "DU": WeatherCondition("Dust", "dust", .sun),
        "SA": WeatherCondition("Sand", "dust", .sun),
        "HZ": WeatherCondition("Haze", "haze", .sun),
        "BLSN": WeatherCondition("Blowing Snow", "snow", .cloud),
        "BLSA": WeatherCondition("Blowing Sand", "fog", .cloud),
        "BLDU": WeatherCondition("Blowing Dust", "fog", .cloud),
        "PO": WeatherCondition("Sand/Dust Whirls", "tornado", .none),
        "FC": WeatherCondition("Funnel Cloud", "tornado", .none),
    ]
    
    /// Prefixes associated to add clouds or a sun to the SF Image
    static let CLOUD_PREFIX = "cloud."
    static let CLOUD_AND_SUN_PREFIX = "cloud.sun."
    static let CLOUD_AND_MOON_PREFIX = "cloud.moon."
    static let SUN_PREFIX = "sun."
    static let MOON_PREFIX = "moon."
}

/// Possible cloud or sun prefixes for SF Images
enum SystemNameSunAndCloud {
    case none
    case cloud
    case sun
    case cloudOrCloudAndSun
    case cloudOrSun
    case cloudAndSun    // only applies to rain and TS (With no rain)
    
    func useCloudAndSun() -> Bool {
        switch self {
        case .cloudAndSun, .cloudOrCloudAndSun:
            return true
        default:
            return false
        }
    }
    func useCloud() -> Bool {
        switch self {
        case .cloud, .cloudOrSun, .cloudAndSun, .cloudOrCloudAndSun:
            return true
        default:
            return false
        }
    }
    func useSun() -> Bool {
        switch self {
        case .sun, .cloudOrSun, .cloudAndSun:
            return true
        default:
            return false
        }
    }
}


