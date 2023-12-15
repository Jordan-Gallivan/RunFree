//
//  ZoneView.swift
//  Run Free
//
//  Created by Jordan Gallivan on 12/8/23.
//

import Foundation
import SwiftData
import SwiftUI

/// Displays current Heart Rate Zone.  This view is not customizable.
struct ZoneView: View {
    @EnvironmentObject private var controller: PolarController
    
    // Query Settings Model.  Only one model in context, ensured at application initialization
    @Environment(\.modelContext) var dbContext
    @Query private var settingsQuery: [SettingsModel]
    private var settings: SettingsModel { settingsQuery.first! }
    
    var body: some View {
        Group {
            switch controller.deviceConnectionState {
            case .connected(_):
                ProgressView("Zone",
                             value: settings.heartRateZones.calcFractionalHr(heartRate: controller.currentHr ?? 0))
                .progressViewStyle(ZoneProgressViewStyle())
            default:
                Text("No Zone Data Available")
            }
        }
//        ProgressView("Zone",
//                     value: settings.heartRateZones.calcFractionalHr(heartRate: 165 ?? 0))
//        .progressViewStyle(ZoneProgressViewStyle())
    }
}

/// Custom Circular progress bar to display current Heart Rate Zone.
struct ZoneProgressViewStyle: ProgressViewStyle {
    @Environment(\.modelContext) var dbContext
    @Query private var settingsQuery: [SettingsModel]
    private var settings: SettingsModel { settingsQuery.first! }
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .trim(from: 0.0,
                      to: CGFloat(configuration.fractionCompleted ?? 0.0))
                .stroke(settings.heartRateZones.currentHeartZone(heartRate: configuration.fractionCompleted)?.zoneColor ?? .primary,
                        style: StrokeStyle(lineWidth: 5, dash: [1, 0, 5]))
                .rotationEffect(.degrees(-90))
                .frame(width: 130)
            if let fraction = configuration.fractionCompleted,
                let zone = settings.heartRateZones.currentHeartZone(heartRate: fraction) {
                Text(zone.rawValue)
                    .fontWeight(.bold)
                    .foregroundStyle(zone.zoneColor)
                    .frame(width: 130)
            }
                    
        }
    }
}
