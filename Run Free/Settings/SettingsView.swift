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
    @State var isAlertVisible: Bool = false
    @State var alertErrorMessage: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("App preferences")) {
                Toggle("Metric Units", isOn: $appData.metric)
                Toggle("12-Hour Clock", isOn: $appData.twelveHourClock)
                Toggle("Use Heart Rate Zones", isOn: $appData.useHeartRateZones)
            }
            if appData.useHeartRateZones {
                Section(header: Text("Heart Rate Zones"), footer: Text("Each value represents the bottom of that zone.")) {
                    HeartRateLine(zoneBottom: $appData.zone1, zoneTop: $appData.zone2, label: "Zone 1", zoneHasTop: true)
                    HeartRateLine(zoneBottom: $appData.zone2, zoneTop: $appData.zone3, label: "Zone 2", zoneHasTop: true)
                    HeartRateLine(zoneBottom: $appData.zone3, zoneTop: $appData.zone4, label: "Zone 3", zoneHasTop: true)
                    HeartRateLine(zoneBottom: $appData.zone4, zoneTop: $appData.zone5, label: "Zone 4", zoneHasTop: true)
                    HeartRateLine(zoneBottom: $appData.zone5, zoneTop: $appData.zone5, label: "Zone 5", zoneHasTop: false)
                }
            }
        }
        .alert(isPresented: $isAlertVisible) {
            Alert(title: Text(alertErrorMessage),
                  message: nil,
                  primaryButton: .default(
                    Text("OK")) {
                        isAlertVisible = false
                    },
                  secondaryButton: .cancel(
                    Text("Disable Heart Rate Zones")) {
                        appData.useHeartRateZones = false
                        isAlertVisible = false
                        appData.viewPath.removeLast()
            })
        }
        .navigationTitle(Text("Settings"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    let (validZones, errorMessage) = appData.areHrZonesValid()
                    if appData.useHeartRateZones && !validZones {
                        alertErrorMessage = errorMessage
                        isAlertVisible = true
                    } else {
                        appData.viewPath.removeLast()
                    }
                }, label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                            .symbolRenderingMode(.palette)
                            .foregroundColor(.accentColor)
                        Text("Back")
                            .foregroundColor(.accentColor)
                    }
                })
            }
        }
        
        // TODO: add sheet if values are nil in HR Zones
    }
}
