//
//  RunComponentSettingsView.swift
//  Run Free
//
//  Created by Jordan Gallivan on 12/5/23.
//

import Foundation
import SwiftUI

/// View to allow users to modify component settings
struct RunComponentSettingsView: View {
    @EnvironmentObject var appData: AppData
    
    /// Computed Bindings to update selected component settings
    private var isTitleVisible: Binding<Bool> {
        Binding { appData.selectedComponentToEdit?.isTitleVisible ?? true }
        set: { appData.selectedComponentToEdit?.isTitleVisible = $0 }
    }
    private var contentSize: Binding<Float> {
        Binding { Float(appData.selectedComponentToEdit?.componentSize ?? 12)}
        set: { appData.selectedComponentToEdit?.componentSize = CGFloat($0) }
    }
    private var contentColor: Binding<String> {
        Binding { appData.selectedComponentToEdit?.componentColorString ?? "primary" }
        set: {
            guard COLOR_OPTIONS.contains($0) else {
                appData.selectedComponentToEdit?.componentColorString = "primary"
                return
            }
            appData.selectedComponentToEdit?.componentColorString = $0
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text("Component Size")
                Slider(value: contentSize, in: 12...100, step: 1.0)
            }
            .padding()
            
            Toggle("Component Label Visible", isOn: isTitleVisible)
                .padding()
                    
            VStack(spacing: 0) {
                Text("Component Color")
                Picker("Component Color", selection: contentColor) {
                    ForEach(COLOR_OPTIONS, id: \.self) { color in
                        Text(color)
                            .tag(color)
                    }
                }
                .pickerStyle(.wheel)
            }
        }
    }     
}
