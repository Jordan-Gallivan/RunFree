//
//  SettingsView.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/8/23.
//

import Foundation
import SwiftUI
import Combine

struct SettingsView: View {
    @EnvironmentObject private var appData: AppData
    
    var body: some View {
        Form {
            Section(header: Text("App preferences")) {
                Toggle("Metric Units", isOn: $appData.metric)
                Toggle("12-Hour Clock", isOn: $appData.twelveHourClock)
                Toggle("Use Heart Rate Zones", isOn: $appData.useHeartRateZones)
            }
            if appData.useHeartRateZones {
                Section(header: Text("Heart Rate Zones"), footer: Text("Each value represents the bottom of that zone.")) {
                    HeartRateLine(zone: $appData.zone1, label: "Zone 1")
                    HeartRateLine(zone: $appData.zone2, label: "Zone 2")
                    HeartRateLine(zone: $appData.zone3, label: "Zone 3")
                    HeartRateLine(zone: $appData.zone4, label: "Zone 4")
                    HeartRateLine(zone: $appData.zone5, label: "Zone 5")
                }
            }
        }
        .navigationTitle(Text("Settings"))
        .navigationBarBackButtonHidden(false)
        // TODO: add sheet if values are nil in HR Zones
    }
}
