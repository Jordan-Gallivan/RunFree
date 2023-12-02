//
//  UrlConstants.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/26/23.
//

import Foundation

public struct UrlConstants {
    /// Search Radius when fetching stations
    static let STATION_SEARCH_RADIUS = 40
        
    static func GET_STATIONS_URL(userLatitude: Double, userLongitude: Double) -> String {
        return "https://aviationweather.gov/cgi-bin/data/dataserver.php?dataSource=stations&requestType=retrieve&format=xml&radialDistance=\(STATION_SEARCH_RADIUS);\(userLongitude),\(userLatitude)"
    }
    static let METAR_URL_PREFIX = "https://aviationweather.gov/cgi-bin/data/metar.php?ids="
    static let TAF_URL_PREFIX = "https://aviationweather.gov/cgi-bin/data/taf.php?ids="
    static func GET_TODAY_SUNRISE_SUNSET_URL(userLatitude: Double, userLongitude: Double) -> String {
        return "https://api.sunrise-sunset.org/json?lat=\(userLatitude)&lng=\(userLongitude)&formatted=0"
    }
    static func GET_TOMORROW_SUNRISE_SUNSET_URL(userLatitude: Double, userLongitude: Double) -> String {
        return "https://api.sunrise-sunset.org/json?lat=\(userLatitude)&lng=\(userLongitude)&formatted=0&date=tomorrow"
    }
    
    static let SUNRISE_SUNSET_URL_PREFIX = "https://api.sunrise-sunset.org/json?"
}
