//
//  RunComponentType.swift
//  Run Free
//
//  Created by Jordan Gallivan on 12/4/23.
//

import Foundation

/// Run Components displayable to user
enum RunComponentType: String, Codable {
    case timer = "Timer"
    case distance = "Distance"
    case pace = "Pace"
    case heartRate = "Heart Rate"
    case zones = "Zone"
}
