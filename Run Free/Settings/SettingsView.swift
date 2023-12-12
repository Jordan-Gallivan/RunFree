//
//  SettingsView.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/8/23.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

/// View to edit Applicaiton User Settings
struct SettingsView: View {
    @EnvironmentObject private var appData: AppData
    
    // Query Settings Model.  Only one model in context, ensured at application initialization
    @Environment(\.modelContext) var dbContext
    @Query private var settingsQuery: [SettingsModel]
    private var settings: SettingsModel { settingsQuery.first! }
    
    // MARK: - Computed Bindings used to update model
    private var metric: Binding<Bool> {
        Binding { settings.metric }
        set: { settings.metric = $0 }
    }
    private var twelveHourClock: Binding<Bool> {
        Binding { settings.twelveHourClock }
        set: { settings.twelveHourClock = $0 }
    }
    private var useHeartRateZones: Binding<Bool> {
        Binding { settings.useHeartRateZones }
        set: { settings.useHeartRateZones = $0 }
    }
    
    // Alert State variables
    @State var isAlertVisible: Bool = false
    @State var alertErrorMessage: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("App preferences")) {
                Toggle("Metric Units", isOn: metric)

                Toggle("12-Hour Clock", isOn: twelveHourClock)

                Toggle("Use Heart Rate Zones", isOn: useHeartRateZones)
            }
            if settings.useHeartRateZones {
                Section(header: Text("Heart Rate Zones"), footer: Text("Each value represents the bottom of that zone.")) {
                    HeartRateLine(heartRateZone: .zone1, label: "Zone 1")
                    HeartRateLine(heartRateZone: .zone2, label: "Zone 2")
                    HeartRateLine(heartRateZone: .zone3, label: "Zone 3")
                    HeartRateLine(heartRateZone: .zone4, label: "Zone 4")
                    HeartRateLine(heartRateZone: .zone5, label: "Zone 5")
                }
            }
        }
        .alert(isPresented: $isAlertVisible) {
            // alert visible if 0 value Heart Rate Zones or non-sequential zones
            Alert(title: Text(alertErrorMessage),
                  message: nil,
                  primaryButton: .default(
                    Text("OK")) {
                        isAlertVisible = false
                    },
                  secondaryButton: .cancel(
                    Text("Disable Heart Rate Zones")) {
                        settings.useHeartRateZones = false
                        isAlertVisible = false
                        appData.viewPath.removeLast()
            })
        }
        .navigationTitle(Text("Settings"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    // validate zones and display alert if invalid
                    let (validZones, errorMessage) = settings.heartRateZones.areHrZonesValid()
                    if settings.useHeartRateZones && !validZones {
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
    }

}
