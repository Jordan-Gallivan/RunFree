//
//  Pace.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/26/23.
//

import Foundation
import SwiftData
import SwiftUI

struct PaceView: View {
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
            Text(String(format: "%d:%02d", appData.pace(metric: settings.metric) / 60, appData.pace(metric: settings.metric) % 60))
                .font(.system(size: componentSize))
                .foregroundStyle(componentColor)
            Text(settings.metric ? "min/km" : "min/mi")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
