//
//  HeartRate.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/16/23.
//

import Foundation
import SwiftData
import SwiftUI

/// Displays the current Heart Rate.
struct HeartRateView: View, RunComponentProperties {
    @EnvironmentObject private var appData: AppData
    @EnvironmentObject private var controller: PolarController
    
    // Query Settings Model.  Only one model in context, ensured at application initialization
    @Environment(\.modelContext) var dbContext
    @Query private var settingsQuery: [SettingsModel]
    private var settings: SettingsModel { settingsQuery.first! }
    
    // MARK: - RunComponentProperties
    var name: String
    var componentSize: CGFloat
    var componentColor: Color

    var body: some View {
        Group {
            if !controller.isBluetoothOn {
                Text("Bluetooth Disabled")
                    .foregroundStyle(.red)
            } else {
                Group {
                    switch controller.deviceConnectionState {
                    case .disconnected(_):
                        VStack {
                            Text("No HR Monitor Connected")
                                .font(.footnote)
                            Button("Auto Connect") {
                                controller.autoConnect()
                            }
                            .buttonStyle(DefaultButton(buttonColor: .teal, textColor: .white))
                        }
                    case .connecting(let deviceId):
                        Text("Connecting \(deviceId)")
                    case .connected(_):
                        VStack {
                            HStack {
                                Text(controller.hrString)
                                    .font(.system(size: componentSize))
                                    .foregroundStyle(componentColor)
                                Text("bpm")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } // end switch
                } // end Group
            } // end conditional
        } // end Group
    } // end body
}
