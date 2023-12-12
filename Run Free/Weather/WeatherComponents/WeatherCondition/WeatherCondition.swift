//
//  Precipitation.swift
//  Run Free
//
//  Created by Jordan Gallivan on 12/7/23.
//

import Foundation
import SwiftUI

/// Struct to associate 2-4 letter weather condition in METAR or TAF with an SF Image suffix and the cloud/sun modifiers for that image.
struct WeatherCondition: Hashable, Identifiable {
    var id = UUID()
    
    static func == (lhs: WeatherCondition, rhs: WeatherCondition) -> Bool {
        return lhs.description == rhs.description
    }
    func hash(into hasher: inout Hasher) {
            hasher.combine(description)
    }
    
    var description: String
    var sfImageSuffix: String
    var modifiers: SystemNameSunAndCloud
    
    init(_ description: String, _ icon: String, _ modifiers: SystemNameSunAndCloud ) {
        self.description = description
        self.sfImageSuffix = icon
        self.modifiers = modifiers
    }
}
