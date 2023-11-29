//
//  StationParser.swift
//  Run Free
//
//  Created by Jordan Gallivan on 9/29/23.
//

import Foundation

/// Delegate XML Parser to parse Station information returned from aviationweather.gov
/// Adds stations to the Heap, which is accessible via the  public variable "stations"
class StationParser: NSObject, XMLParserDelegate {
    var stations: PriorityQueue<Airport>? = nil
    var currentStation: Airport? = nil
    var currentProperty:AirportElements? = nil
    let userLatitude: Double
    let userLongitude: Double
    
    init(userLatitude: Double, userLongitude: Double) {
        self.userLatitude = userLatitude
        self.userLongitude = userLongitude
        stations = PriorityQueue<Airport>()
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentProperty = AirportElements(rawValue: elementName)
        
        if currentProperty == AirportElements.Station {
            currentStation = Airport()
        } else if currentProperty == .METAR || currentProperty == .TAF {
            currentStation?.updateMetarOrTaf(optionalProperty: currentProperty!)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let currentProperty = currentProperty,
        string.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            return
        }
        
        if currentProperty != .METAR || currentProperty != .TAF {
            currentStation?.updateMandatoryProperty(mandatoryProperty: currentProperty, value: string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard elementName == AirportElements.Station.rawValue else {
            return
        }
        currentStation?.calcDistanceToUser(userLatitude: userLatitude, userLongitude: userLongitude)
        if currentStation?.distanceToUser == 0 {
            print("INVALID USER DISTANCE")
        }
        
        stations?.add(currentStation)
    }
    
}
