//
//  SettingsModel.swift
//  Run Free
//
//  Created by Jordan Gallivan on 12/6/23.
//

import Foundation
import SwiftData

/// Model to store user application settings
@Model
class SettingsModel: Identifiable {
    // MARK: - Identifiable
    var id: UUID = UUID()
    
    // MARK: - User Settings
    var metric: Bool = false
    var twelveHourClock: Bool = false
    var useHeartRateZones: Bool = false
    var heartRateZones: HeartRateZoneSettings = HeartRateZoneSettings()
    
    init(metric: Bool = false, twelveHourClock: Bool = false, useHeartRateZones: Bool = false) {
        self.metric = metric
        self.twelveHourClock = twelveHourClock
        self.useHeartRateZones = useHeartRateZones
    }
}
