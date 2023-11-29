//
//  HeartRate.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/16/23.
//

import Foundation
import SwiftUI

struct HeartRate: View {
    @EnvironmentObject private var appData: AppData
    @EnvironmentObject private var controller: PolarController

    var body: some View {
        DisplayLine(name: "HR") {
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
                                    Text(controller.hr)
                                        .font(.largeTitle)
                                    Text("bpm")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                if appData.useHeartRateZones {
                                    Text(appData.currentHeartZone!.rawValue)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
