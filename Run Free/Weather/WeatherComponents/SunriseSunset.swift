//
//  SunriseSunset.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/29/23.
//

import Foundation

struct SunriseSunsetParser: Codable {
    enum Status: String, Codable {
        case OK, INVALID_REQUEST, INVALID_DATE, UNKNOWN_ERROR
    }
    
    var results: SunriseSunset
    var status: Status
    
}

struct SunriseSunset: Codable {
    let sunrise: String
    let sunset: String
}

struct SunriseSunsetDateObject {
    let sunriseSunset: SunriseSunset
    
    private let dateFormatString = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    private let dateFormatter = DateFormatter()
    
    var sunriseDateObject: Date {
        get {
            return convertToDateObject(sunriseSunset.sunrise)
        }
    }
    
    var sunsetDateObject: Date {
        get {
            return convertToDateObject(sunriseSunset.sunset)
        }
    }
    
    
    private func convertToDateObject(_ time: String) -> Date {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormatString
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: time)!
    }
    
}
