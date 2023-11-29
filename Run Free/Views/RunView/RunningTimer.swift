//
//  Time.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/16/23.
//

import Foundation
import SwiftUI



struct RunningTimer: View {
    @EnvironmentObject private var appData: AppData
    
    var displayTime: String {
        var eT = appData.elapsedTime
        let hours = eT / 3600000
        eT %= 3600000
        let minutes = eT / 60000
        eT %= 60000
        let seconds = eT / 1000
        
        
        switch appData.currentTimeFormat {
        case .seconds:
            eT %= 1000
            let decimalSeconds = eT / 100
            return "\(seconds).\(decimalSeconds)"
        case .minutes:
            return "\(minutes):\(seconds)"
        case .hours:
            return "\(hours):\(minutes):\(seconds)"
        }
    }
    var body: some View {
        DisplayLine(name: "Time") {
            Text(displayTime)
                .font(.largeTitle)
                .fontWeight(.bold)
        }
    }
}
