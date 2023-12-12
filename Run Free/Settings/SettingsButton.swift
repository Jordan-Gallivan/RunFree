//
//  SettingsButton.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/27/23.
//

import Foundation
import SwiftUI

/// Custom Button to display and link to settings page
struct SettingsButton: View {
    @EnvironmentObject private var appData: AppData
    
    var body: some View {
        Button(action: {
            appData.viewPath.append("Settings View")
        }, label: {
            Image(systemName: "gearshape")
        })
    }
}
