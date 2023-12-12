//
//  Airport.swift
//  Run Free
//
//  Created by Jordan Gallivan on 9/27/23.
//

import Foundation

/// Struct to parse XML for stations retreived from aviationweather.gov
enum AirportElements:String, Equatable {
    case Station, station_id, latitude, longitude, METAR, TAF
}

/// Struct for storing station information.  Station is considered less than another if it is closer to the user.
struct Airport: Comparable {
    var stationID: String
    var latitude: Double
    var longitude: Double
    var distanceToUser: Double
    var hasMetar = false
    var hasTaf = false
    var metar: Metar? = nil
    
    init() {
        stationID = ""
        latitude = 0.0
        longitude = 0.0
        distanceToUser = 0
    }
    
    /// Update required station information: Station ID, Latitude, or Longitude.
    ///
    /// - Parameters:
    ///    - mandatoryProperty: Property to be updated.
    ///    - value: String to update the property to.
    mutating func updateMandatoryProperty(mandatoryProperty property: AirportElements, value: String) {
        switch (property) {
        case .station_id:
            stationID = value
        case .latitude:
            latitude = Double(value) ?? 0.0
        case .longitude:
            longitude = Double(value) ?? 0.0
        default:
            break
        }
    }
    
    mutating func updateMetarOrTaf(optionalProperty property: AirportElements) {
        switch property {
        case .METAR:
            hasMetar = true
        case .TAF:
            hasTaf = true
        default:
            break
        }
    }
    
    mutating func calcDistanceToUser(userLatitude: Double, userLongitude: Double) {
        distanceToUser = sqrt(pow(userLatitude - latitude, 2) + pow(userLongitude - longitude, 2))
    }
    
    /// Left hand side is considered less than right hand side if it is closer to the user.
    static func < (lhs: Airport, rhs: Airport) -> Bool {
        return lhs.distanceToUser < rhs.distanceToUser
    }
    
    static func == (lhs: Airport, rhs: Airport) -> Bool {
        return lhs.distanceToUser == rhs.distanceToUser
    }
}



