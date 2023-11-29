//
//  Forecast.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/19/23.
//

import Foundation
import SwiftUI

/// Forecast components of a TAF Line.
struct Forecast: Hashable {
    static func == (lhs: Forecast, rhs: Forecast) -> Bool {
        return lhs.date == rhs.date && lhs.time == rhs.time
    }
    func hash(into hasher: inout Hasher) {
            hasher.combine(date)
            hasher.combine(time)
    }
    
    var date = 0
    var time = 0
    var windDirection: String? = nil
    var windSpeed: Int? = nil
    var precipitation: [Precipitation]? = nil
    var clouds: Clouds? = nil
    var probability:Int? = nil
    var sunrise: Bool = false
    var sunset: Bool = false
    var night: Bool = false
    var dateObject: Date
    var backgroundColor: Color = Color(red: 0, green: 0, blue: 0, opacity: 0)
    
    var windIcon: Bool {
        get {
            guard let windSpeed else {
                return false
            }
            return windSpeed >= 20
        }
    }
    
    func convertedWindSpeed(metric: Bool) -> Int? {
        guard let windSpeed else {
            return nil
        }
        return metric
            ? Int(Double(windSpeed) * 1.852)
            : Int(Double(windSpeed) * 1.15078)
    }
    
    
}
