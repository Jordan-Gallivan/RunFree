//
//  DefaultButton.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/27/23.
//

import Foundation
import SwiftUI

/// Default button with custom styling 
struct DefaultButton: ButtonStyle {
    let buttonColor: Color
    let textColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(buttonColor)
            .foregroundStyle(textColor)
            .clipShape(Capsule())
            .shadow(radius: CGFloat(2), x: CGFloat(2), y: CGFloat(2))
    }
    
}
