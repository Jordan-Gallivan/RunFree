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
public enum Clouds: String, Comparable {
    case OVC //= "Overcast"
    case BKN //= "Broken"
    case SCT //= "Scattered"
    case FEW //= "Few"
    case SKC //= "Skies Clear"
    
    public static func < (lhs: Clouds, rhs: Clouds) -> Bool {
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
    
    public static func == (lhs: Clouds, rhs: Clouds) -> Bool {
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
    
    func cloudImage(night: Bool) -> Image {
        switch self {
        case .SKC:
            fallthrough
        case .FEW:
            return Image(systemName: night ? "moon.stars" : "sun.max")
        case .SCT:
            return Image(systemName: night ? "cloud.moon" : "cloud.sun")
        case .BKN:
            fallthrough
        case .OVC:
            return Image(systemName: "cloud")
        }
    }
}
