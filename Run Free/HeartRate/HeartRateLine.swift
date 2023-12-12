//
//  HeartRateLine.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/9/23.
//

import Foundation
import SwiftData
import SwiftUI

/// Accepts user input for Heart Rate Zone value
struct HeartRateLine: View {
    
    // Query Settings Model.  Only one model in context, ensured at application initialization
    @Environment(\.modelContext) var dbContext
    @Query private var settingsQuery: [SettingsModel]
    private var settings: SettingsModel { settingsQuery.first! }
    
    var label: String
    private var bottomZone: HeartRateZones
    private var topZone: HeartRateZones

    // Computed Bindings to update model
    private var bottomZoneValue: Binding<Int?> {
        Binding { settings.heartRateZones.fetchHeartRateZone(bottomZone) }
        set: { settings.heartRateZones.updateHeartRateZone(bottomZone, newValue: $0) }
    }
    private var topZoneValue: Binding<Int?> {
        Binding { settings.heartRateZones.fetchHeartRateZone(topZone) }
        set: { settings.heartRateZones.updateHeartRateZone(topZone, newValue: $0) }
    }    
    
    
//    private let hrFormatter: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.locale = Locale.current
//        formatter.numberStyle = .none
////        formatter.zeroSymbol = ""
//        return formatter
//    }()
    
    var body: some View {
        HStack {
            Text("\(label): ")
            TextField("", value: bottomZoneValue, format: .number)
                .keyboardType(.numberPad)

            if topZone != .maxEffort {
                Text("to")
                TextField("", value: topZoneValue, format: .number)
                    .keyboardType(.numberPad)
            } else {
                Text("+")
                Spacer()
            }
        }
    }
        
    
    init(heartRateZone zone: HeartRateZones, label: String) {
        self.label = label
        switch zone {
        case .zone1:
            self.bottomZone = .zone1
            self.topZone = .zone2
        case .zone2:
            self.bottomZone = .zone2
            self.topZone = .zone3
        case .zone3:
            self.bottomZone = .zone3
            self.topZone = .zone4
        case .zone4:
            self.bottomZone = .zone4
            self.topZone = .zone5
        case .zone5:
            self.bottomZone = .zone5
            self.topZone = .maxEffort
        default:
            self.bottomZone = .warmUp
            self.topZone = .maxEffort
        }
    }
    
    
}
