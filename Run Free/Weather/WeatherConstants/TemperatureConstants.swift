//
//  TemperatureConstants.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/26/23.
//

import Foundation
import SwiftUI

public struct TemperatureIconOptions {
    public let image: Image
    public let lightModeColors: [Color]
    public let darkModeColors: [Color]
}

public enum TemperatureExtremes {
    case cold
    case hot
    case normal
    
    func temperatureImage() -> Image? {
        switch self {
        case .hot:
            return Image(systemName: "thermometer.sun")
        case .cold:
            return Image(systemName: "thermometer.snowflake")
        default:
            return nil
        }
    }
}
