//
//  Time.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/16/23.
//

import Foundation
import SwiftUI

/// Displays the elapsed Timer.
struct ElapsedTimerView: View {
    @EnvironmentObject private var appData: AppData
    
    // MARK: - RunComponentProperties
    var name: String
    var componentSize: CGFloat
    var componentColor: Color
    
    var displayTime: String {
        // calculate hours, minutes, and seconds
        var eT = appData.elapsedTime
        let hours = eT / 3600000
        eT %= 3600000
        let minutes = eT / 60000
        eT %= 60000
        let seconds = eT / 1000
        
        // format and return elapsed time
        switch appData.currentTimeFormat {
        case .seconds:
            eT %= 1000
            let decimalSeconds = eT / 100
            return "\(seconds).\(decimalSeconds)"
        case .minutes:
            return String(format: "%d:%02d", minutes, seconds)
        case .hours:
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
    }
    var body: some View {
        Text(displayTime)
            .font(.system(size: componentSize))
            .fontWeight(.bold)
            .foregroundStyle(componentColor)
    }
}
