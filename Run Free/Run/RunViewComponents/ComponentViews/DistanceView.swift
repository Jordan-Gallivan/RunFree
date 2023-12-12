//
//  Distance.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/16/23.
//

import Foundation
import SwiftData
import SwiftUI

/// Displays the elapsed distance.
struct DistanceView: View {
    @EnvironmentObject private var appData: AppData
    
    // Query Settings Model.  Only one model in context, ensured at application initialization
    @Environment(\.modelContext) var dbContext
    @Query private var settingsQuery: [SettingsModel]
    private var settings: SettingsModel { settingsQuery.first! }
    
    // MARK: - RunComponentProperties
    var name: String
    var componentSize: CGFloat
    var componentColor: Color

    var body: some View {
                HStack {
                    Text(String(format: "%.2f", appData.elapsedDistance(isMetric: settings.metric)))
                        .font(.system(size: componentSize))
                        .foregroundStyle(componentColor)
                    Text(settings.metric ? "km" : "mi")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
//        ZStack(alignment: .centerComponent) {
//            Text(String(format: "%.2f", appData.elapsedDistance(metric: settings.metric)))
//                .font(.system(size: componentSize))
//                .alignmentGuide(.runComponentCenter) { alignment in
//                    alignment[HorizontalAlignment.trailing]
//                }
//            Text(settings.metric ? "km" : "mi")
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//                .alignmentGuide(.runComponentCenter) { alignment in
//                    alignment[HorizontalAlignment.leading]
//                }
//        }
    
    }
}
