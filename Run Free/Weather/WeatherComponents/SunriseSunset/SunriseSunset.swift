//
//  SunriseSunset.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/29/23.
//

import Foundation

/// Struct for initial JSON parsing of data from sunrise-sunset.org
struct SunriseSunsetParser: Codable {
    enum Status: String, Codable {
        case OK, INVALID_REQUEST, INVALID_DATE, UNKNOWN_ERROR
    }
    
    var results: SunriseSunset
    var status: Status
    
}

/// Struct for  JSON parsing of data from sunrise-sunset.org
struct SunriseSunset: Codable {
    let sunrise: String
    let sunset: String
}

/// converts sunrise and sunset strings into associated Date objects.
struct SunriseSunsetDateObject {
    let sunriseSunset: SunriseSunset
    
    private let dateFormatString = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    private let dateFormatter = DateFormatter()
    
    var sunriseDateObject: Date { convertToDateObject(sunriseSunset.sunrise) }
    
    var sunsetDateObject: Date { convertToDateObject(sunriseSunset.sunset)}
        
    private func convertToDateObject(_ time: String) -> Date {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormatString
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: time)!
    }
    
}
