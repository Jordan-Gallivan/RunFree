//
//  HeartRateZones.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/9/23.
//

import Foundation
import SwiftUI

/// Heart Rate Zone Definitions
enum HeartRateZones: String {
    case warmUp = "Warm Up"
    case zone1 = "Zone 1"
    case zone2 = "Zone 2"
    case zone3 = "Zone 3"
    case zone4 = "Zone 4"
    case zone5 = "Zone 5"
    case maxEffort = "Max Effort"
    
    /// Color associated with Heart Rate Zone
    var zoneColor: Color {
        switch self {
        case .warmUp:
            return .green
        case .zone1:
            return .teal
        case .zone2:
            return .blue
        case .zone3:
            return .yellow
        case .zone4:
            return .orange
        case .zone5, .maxEffort:
            return .red
        }
    }
}

/// Utility struct to store User Heart Rate Zones and calculate data needed for component displays
struct HeartRateZoneSettings: Codable {
    // MARK: - Integer Zone Components
    private var zone1: Int? = nil
    private var zone2: Int? = nil
    private var zone3: Int? = nil
    private var zone4: Int? = nil
    private var zone5: Int? = nil
    
    // distance between zone1 and maximum heart rate value for display in ZoneView()
    private var max: Double {
        guard let zone1, let zone5 else {
            return 250
        }
        let doubleZone5 = Double(zone5)
        let doubleZone1 = Double(zone1)
        return ((doubleZone5 - 0.05 * doubleZone1) / 0.95) - doubleZone1
    }
    
    // MARK: - Fractional Zone values
    private var fracZone1: Double = 0.1
    private var fracZone2: Double {
        guard let zone1, let zone2 else {
            return 0.0
        }
        return Double(zone2 - zone1) / max
    }
    private var fracZone3: Double {
        guard let zone1, let zone3 else {
            return 0.0
        }
        return Double(zone3 - zone1) / max
    }
    private var fracZone4: Double {
        guard let zone1, let zone4 else {
            return 0.0
        }
        return Double(zone4 - zone1) / max
    }
    private var fracZone5: Double = 0.95
    
    /// Updates the integer zone value
    ///
    /// - Parameters:
    ///    - zone: zone to be updated.
    ///    - newValue: updated integer zone value.
    mutating func updateHeartRateZone(_ zone: HeartRateZones, newValue: Int?) {
        switch zone {
        case .zone1:
            self.zone1 = newValue
        case .zone2:
            self.zone2 = newValue
        case .zone3:
            self.zone3 = newValue
        case .zone4:
            self.zone4 = newValue
        case .zone5:
            self.zone5 = newValue
        default:
            break
        }
    }
    
    /// Returns the integer Heart Rate for provided zone.
    ///
    /// - Parameter zone: Zone to fetch Heart Rate For
    /// - Returns: Integer Heart Rate associated with provided zone or nil if provided .warmUp or .maxEffort as these values do not correspond to a Heart Rate.
    func fetchHeartRateZone(_ zone: HeartRateZones) -> Int? {
        switch zone {
        case .zone1:
            return self.zone1
        case .zone2:
            return self.zone2
        case .zone3:
            return self.zone3
        case .zone4:
            return self.zone4
        case .zone5:
            return self.zone5
        default:
            return nil
        }
    }
    
    /// Calculates the fractional Heart Rate for use in the ZoneView Progress View.
    /// - Parameter heartRate: Integer Heart Rate.
    ///
    /// - Returns: A value in range 0...1.0, that represents the fractional distance between zone1 and the maximum Heart Rate.
    func calcFractionalHr(heartRate: Int) -> Double {
        guard let zone1 else {
            return 0.0
        }
        if heartRate < zone1 {
            return 0.0
        }
        let fractionHr = Double(heartRate - zone1) / max
        return min(fractionHr, 1.0)
    }
    
    /// Returns the current Heart Rate Zone associated with the provided Integer Heart Rate.
    ///
    /// - Parameter heartRate: Integer current Heart Rate.
    /// - Returns: Heart Rate Zone for current Heart Rate.
    func currentHeartZone(heartRate: Int) -> HeartRateZones? {
        guard let zone1, let zone2, let zone3, let zone4, let zone5 else {
            return nil
        }
        switch heartRate {
        case 0..<zone1:
            return .warmUp
        case zone1..<zone2:
            return .zone1
        case zone2..<zone3:
            return .zone2
        case zone3..<zone4:
            return .zone3
        case zone4..<zone5:
            return .zone4
        case zone5..<250:
            return .zone5
        default:
            return nil
        }
    }
    
    /// Returns the current Heart Rate Zone associated with the provided fractional Heart Rate.
    ///
    /// - Parameter heartRate: current fractional Heart Rate.
    /// - Returns: Heart Rate Zone for current fractional Heart Rate or nil if no Heart Rate provided.
    func currentHeartZone(heartRate: Double?) -> HeartRateZones? {
        guard let heartRate else {
            return nil
        }
        if heartRate < 0.0 {
            return .warmUp
        }
        if heartRate >= fracZone5 {
            return .zone5
        }
        if heartRate >= fracZone4 {
            return .zone4
        }
        if heartRate >= fracZone3 {
            return .zone3
        }
        if heartRate >= fracZone2 {
            return .zone2
        }
        return .zone1
    }
    
    /// Validates that all zones are in sequential order and non-zero.
    ///
    /// - Returns (true, "") if zones are valid, otherwise (false, associated error message).
    /// zone1 < zone2 < zone3 < zone4 < zone5
    func areHrZonesValid() -> (Bool, String) {
        guard let zone1, let zone2, let zone3, let zone4, let zone5 else {
            return (false, "Heart Rate Zones must be greater than 0")
        }
        if !(zone1 != 0 && zone2 != 0 && zone3 != 0 && zone4 != 0 && zone5 != 0) {
            return (false, "Heart Rate Zones must be greater than 0")
        }
        if zone1 < zone2 && zone2 < zone3 && zone3 < zone4 && zone4 < zone5 {
            return (true, "")
        }
        var errorMessage = ""
        if zone1 >= zone2 {
            errorMessage.append("Zone 1 must be less than Zone 2. \n")
        }
        if zone2 >= zone3 {
            errorMessage.append("Zone 2 must be less than Zone 3. \n")
        }
        if zone3 >= zone4 {
            errorMessage.append("Zone 3 must be less than Zone 4. \n")
        }
        if zone4 >= zone5 {
            errorMessage.append("Zone 4 must be less than Zone 5. \n")
        }
        
        return (false, errorMessage)
    }
    
    /// Resets all zones to nil.
    mutating func resetHrZones() {
        self.zone1 = nil
        self.zone2 = nil
        self.zone3 = nil
        self.zone4 = nil
        self.zone5 = nil
    }
}
