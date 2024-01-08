//
//  CloudConstants.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/26/23.
//

import Foundation
import SwiftUI

/// Cloud conditions
let SKY_CONDITIONS: Set<String> = [
    "SKC",
    "NCD",
    "CLR",
    "NSC",
    "FEW",
    "SCT",
    "BKN",
    "OVC",
    "TCU",
    "CB",
    "VV",
]

/// Cloud Conditions used to determine the prevailing cloud coverage.
///  Overcast > Broken > Scattered > Few > Skies Clear
enum Clouds: String, Comparable {
    case OVC //= "Overcast"
    case BKN //= "Broken"
    case SCT //= "Scattered"
    case FEW //= "Few"
    case SKC //= "Skies Clear"
    
    static func < (lhs: Clouds, rhs: Clouds) -> Bool {
        switch (lhs, rhs) {
        case (.OVC, .OVC):
            return false
        case (.BKN, .BKN):
            return false
        case (.SCT, .SCT):
            return false
        case (.FEW, .FEW):
            return false
        case (.SKC, .SKC):
            return false
        case (.SKC, _):
            return true
        case (_, .SKC):
            return false
        case (_, .OVC):
            return true
        case (.OVC, _):
            return false
        case (_, .BKN):
            return true
        case (.BKN, _):
            return false
        case (_, .SCT):
            return true
        case (.SCT, _):
            return false
        default:
            return false
        }
    }
    
    static func == (lhs: Clouds, rhs: Clouds) -> Bool {
        switch (lhs, rhs) {
        case (.OVC, .OVC):
            return true
        case (.BKN, .BKN):
            return true
        case (.SCT, .SCT):
            return true
        case (.FEW, .FEW):
            return true
        case (.SKC, .SKC):
            return true
        default:
            return false
        }
    }
    
    func cloudString() -> String {
        switch self {
        case .OVC:
            return "Overcast"
        case .BKN:
            return "Cloudy"
        case .SCT:
            return "Partially Cloudy"
        case .FEW:
            return "Few Clouds"
        case .SKC:
            return "Clear Skies"
        }
    }
    
    func cloudImage(night: Bool) -> WeatherImage {
        switch self {
        case .SKC, .FEW:
            if night {
                return WeatherImage(image: Image(systemName: "moon.stars").symbolRenderingMode(.palette),
                                    lightModeColors: [.primary, .yellow, .primary],
                                    darkModeColors: [.primary, .white, .primary]
                )
            } else {
                return WeatherImage(image: Image(systemName: "sun.max.fill").symbolRenderingMode(.palette),
                                    lightModeColors: [.yellow, .primary, .primary],
                                    darkModeColors: [.yellow, .primary, .primary]
                )
            }
        case .SCT:
            if night {
                return WeatherImage(image: Image(systemName: "cloud.moon").symbolRenderingMode(.palette),
                                    lightModeColors: [.primary, .primary, .primary],
                                    darkModeColors: [.primary, .white, .primary]
                )
            } else {
                return WeatherImage(image: Image(systemName: "cloud.sun").symbolRenderingMode(.palette),
                                    lightModeColors: [.primary, .yellow, .primary],
                                    darkModeColors: [.primary, .yellow, .primary]
                )
            }
        case .BKN, .OVC:
            return WeatherImage(image: Image(systemName: "cloud"),
                                lightModeColors: [.primary, .primary, .primary],
                                darkModeColors:[.primary, .primary, .primary]
            )
        }
    }
}
