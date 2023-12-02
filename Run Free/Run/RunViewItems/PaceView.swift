//
//  Pace.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/26/23.
//

import Foundation
import SwiftUI

struct PaceView: View {
    @EnvironmentObject private var appData: AppData

    var body: some View {
        DisplayLine(name: "Pace") {
            HStack {
                Text(String(format: "%d:%02d", appData.pace / 60, appData.pace % 60))
                    .font(.largeTitle)
                Text(appData.metric ? "min/km" : "min/mi")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
