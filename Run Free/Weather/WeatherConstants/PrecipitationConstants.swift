//
//  PrecipitationConstants.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/26/23.
//

import Foundation
import SwiftUI

final class PrecipitationConstants {
    /// TwoLetterIdentifier: (precipitationString, systemName, optionalCloudOrSun)
    ///
    /// if !useSun() -> prefix is automatically cloud.
    static let PRECIPITATION_DICTIONARY: [String : Precipitation] = [
        "DZ": Precipitation("Drizzile", "rain", .cloudAndSun),
        "RA": Precipitation("Rain", "rain", .cloudAndSun),
        "SN": Precipitation("Snow", "snow", .cloud),
        "SG": Precipitation("Snow Grains", "snow", .cloudOrSun),
        "IC": Precipitation("Ice Crystals", "snow", .cloudOrSun),
        "PL": Precipitation("Ice Pelelts", "snow", .cloudOrSun),
        "GR": Precipitation("Hail", "hail", .cloud),
        "GS": Precipitation("Small Hail", "hail", .cloud),
        "TS": Precipitation("Thunderstorm", "bolt.custom", .cloudAndSun),
        "VCTS": Precipitation("Thunderstorm", "bolt.custom", .cloudAndSun),
        "TSRA": Precipitation("Thunderstorm and Rain", "bolt.rain.custom", .cloud),
        "TSSN": Precipitation("Thunderstorm and Snow", "bolt.custom", .cloud),
        "TSPL": Precipitation("Thunderstorm and Ice Pellets", "bolt.custom", .cloud),
        "TSGS": Precipitation("Thunderstorm and Snow Grains", "bolt.custom", .cloud),
        "TSGR": Precipitation("Thunderstorm and Hail", "bolt.custom", .cloud),
        "SH": Precipitation("Showers", "rain", .cloudAndSun),
        "VCSH": Precipitation("Showers", "heavyrain", .cloud),
        "SHRA": Precipitation("Rain Showers", "heavyrain", .cloud),
        "SHSN": Precipitation("Snow Showers", "snow", .cloudOrSun),
        "SHPL": Precipitation("Showers of Ice Pellets", "snow", .cloudOrSun),
        "SHGR": Precipitation("Hail Showers", "hail", .cloud),
        "SHGS": Precipitation("Small Hail Showers", "hail", .cloud),
        "FZDZ": Precipitation("Freezing Drizzle", "snow", .cloudOrSun),
        "FZRA": Precipitation("Freezing Rain", "snow", .cloudOrSun),    // TODO: potentially change to rain
        "FZFG": Precipitation("Freezing Drizzle", "fog", .cloud),
        "BR": Precipitation("Mist", "fog", .cloud),
        "FG": Precipitation("Fog", "fog", .cloud),
        "FU": Precipitation("Smoke", "fog", .cloud),
        "VA": Precipitation("Volcanic Ash", "fog", .cloud),
        "DU": Precipitation("Dust", "dust", .sun),
        "SA": Precipitation("Sand", "dust", .sun),
        "HZ": Precipitation("Haze", "haze", .sun),
        "BLSN": Precipitation("Blowing Snow", "snow", .cloud),
        "BLSA": Precipitation("Blowing Sand", "fog", .cloud),
        "BLDU": Precipitation("Blowing Dust", "fog", .cloud),
        "PO": Precipitation("Sand/Dust Whirls", "tornado", .none),
        "FC": Precipitation("Funnel Cloud", "tornado", .none),
    ]
    
    static let CLOUD_PREFIX = "cloud."
    static let CLOUD_AND_SUN_PREFIX = "cloud.sun."
    static let CLOUD_AND_MOON_PREFIX = "cloud.moon."
    static let SUN_PREFIX = "sun."
    static let MOON_PREFIX = "moon."
}

struct Precipitation: Hashable, Identifiable {
    var id = UUID()
    
    static func == (lhs: Precipitation, rhs: Precipitation) -> Bool {
        return lhs.description == rhs.description
    }
    func hash(into hasher: inout Hasher) {
            hasher.combine(description)
    }
    
    var description: String
    var icon: String
    var modifiers: SystemNameSunAndCloud
    
    init(_ description: String, _ icon: String, _ modifiers: SystemNameSunAndCloud ) {
        self.description = description
        self.icon = icon
        self.modifiers = modifiers
    }
}

enum SystemNameSunAndCloud {
    case none
    case cloud
    case sun
    case cloudOrCloudAndSun
    case cloudOrSun
    case cloudAndSun    // only applies to rain and TS (With no rain)
    
    func useCloudAndSun() -> Bool {
        switch self {
        case .cloudAndSun:
            fallthrough
        case .cloudOrCloudAndSun:
            return true
        default:
            return false
        }
    }
    func useCloud() -> Bool {
        switch self {
        case .cloud:
            fallthrough
        case .cloudOrSun:
            fallthrough
        case .cloudAndSun:
            fallthrough
        case .cloudOrCloudAndSun:
            return true
        default:
            return false
        }
    }
    func useSun() -> Bool {
        switch self {
        case .sun:
            fallthrough
        case .cloudOrSun:
            fallthrough
        case .cloudAndSun:
            return true
        default:
            return false
        }
    }
}

struct PrecipitationOptions {
    let weatherIcon: Image
    let colors: [Color]
}
