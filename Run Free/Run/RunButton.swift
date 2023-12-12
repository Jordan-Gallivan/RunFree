//
//  RunButton.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/27/23.
//

import Foundation
import SwiftUI

/// Custom button to navigate to Run View.
struct RunButton: View {
    @EnvironmentObject private var appData: AppData
    
    var body: some View {
        Button(action: {
            appData.viewPath.append("Run View")
        }, label: {
            HStack {
                Image(systemName: "figure.run")
                Text("Run!")
            }
            .font(.title2)
            .clipShape(Capsule())
            
        })
        .buttonStyle(DefaultButton(buttonColor: .green, textColor: .white))
    }
}
