//
//  Distance.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/16/23.
//

import Foundation
import SwiftUI

struct Distance: View {
    @EnvironmentObject private var appData: AppData

    var body: some View {
        DisplayLine(name: "Distance") {
            HStack {
                Text(String(format: "%.2f", appData.elapsedDistance))
                    .font(.largeTitle)
                Text(appData.metric ? "km" : "mi")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
