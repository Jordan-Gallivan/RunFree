//
//  ApplicationData.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/9/23.
//

import Foundation
import SwiftUI
import MapKit

class AppData: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    
    /** User Settings */
    @Published var viewPath = NavigationPath()
    @Published var metric: Bool = false
    @Published var twelveHourClock: Bool = false
    @Published var useHeartRateZones: Bool = false
    
    /** Heart Rate Components */
    @Published var heartRate: Int = 0
    @Published var zone1: Int?
    @Published var zone2: Int?
    @Published var zone3: Int?
    @Published var zone4: Int?
    @Published var zone5: Int?
    var currentHeartZone: HeartRateZones? {
        guard let zone1, let zone2, let zone3, let zone4, let zone5 else {
            return nil
        }
        switch heartRate {
        case 0..<zone1:
            return .warmUp
        case zone1..<zone2:
            return .zone1
        case zone2..<zone3:
            return .zone2
        case zone3..<zone4:
            return .zone3
        case zone4..<zone5:
            return .zone4
        case zone5..<250:
            return .zone5
        default:
            return nil
        }
    }
    func areHrZonesValid() -> (Bool, String) {
        guard let zone1, let zone2, let zone3, let zone4, let zone5 else {
            return (false, "Heart Rate Zones must be greater than 0")
        }
        if !(zone1 != 0 && zone2 != 0 && zone3 != 0 && zone4 != 0 && zone5 != 0) {
            return (false, "Heart Rate Zones must be greater than 0")
        }
        if zone1 < zone2 && zone2 < zone3 && zone3 < zone4 && zone4 < zone5 {
            return (true, "")
        }
        var errorMessage = ""
        if zone1 >= zone2 {
            errorMessage.append("Zone 1 must be less than Zone 2. \n")
        }
        if zone2 >= zone3 {
            errorMessage.append("Zone 2 must be less than Zone 3. \n")
        }
        if zone3 >= zone4 {
            errorMessage.append("Zone 3 must be less than Zone 4. \n")
        }
        if zone4 >= zone5 {
            errorMessage.append("Zone 4 must be less than Zone 5. \n")
        }
        
        return (false, errorMessage)
    }
    
    /** Run View Components */
    @Published var timerActive: Bool = false
    @Published var timerPaused: Bool = false
    
    /* Time Componenets */
    @Published var timer: Timer? = nil
    @Published var elapsedTime: Int = 0  // milliseconds
    @Published var currentTimeFormat: CurrentTimeFormat = .seconds
    
    /* Distance Components */
    private var prevLocation: CLLocation?
    private var currentLocation: CLLocation?
    private var elapsedDistanceInMeters: Double = 0
    var elapsedDistance: Double {
        return metric ? self.elapsedDistanceInMeters / 1000.0 : self.elapsedDistanceInMeters / 1609.34
    }
    
    /* Pace Components */
    private var distanceFiveSecondsAgo: Double = 0
    var paceSecondsPerMeter: Double = 0 // seconds per meter
    var pace: Int {
        return Int(metric ? self.paceSecondsPerMeter * 1000 : self.paceSecondsPerMeter * 1609.34)
    }
    
    @MainActor
    func activateElapsedTimer() async {
        
        self.prevLocation = manager.location
        self.currentLocation = manager.location
        
        self.timerActive = true
        self.timerPaused = false
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (t) in
            
            
            self.elapsedTime += 100
            self.currentTimeFormat.updateTimeFormat(elapsedTime: self.elapsedTime)

            // TODO: update heart rate
            
            // update distance every 1 second
            if self.elapsedTime % 1000 == 0 {
                self.currentLocation = self.manager.location    // TODO: handle error in fetching userlocaiton
                guard let currLoc = self.currentLocation, let prevLoc = self.prevLocation else {
                    // TODO: error handling
                    NSLog("Invalid distance calculation.  \(Date())")
                    return
                }
                let deltaDistance = currLoc.distance(from: prevLoc)
                let deltaAltitude = currLoc.altitude - prevLoc.altitude
                self.elapsedDistanceInMeters += sqrt(pow(deltaDistance, 2) + pow(deltaAltitude, 2))
                self.prevLocation = currLoc
            }

            // update pace every 5 seconds
            if self.elapsedTime % 5000 == 0 {
                self.paceSecondsPerMeter = 5.0 / (self.elapsedDistanceInMeters - self.distanceFiveSecondsAgo)
                self.distanceFiveSecondsAgo = self.elapsedDistanceInMeters
            }
        }
    }
    
    func pauseElapsedTimer() {
        self.timer?.invalidate()
        self.timerPaused = true
        self.timerActive = false
    }
    
    func deactivateElapsedTimer() {
        self.timer?.invalidate()
        self.timer = nil
        self.timerActive = false
        self.timerPaused = false
        self.elapsedTime = 0
    }
    
    @Published var runViewItems: [RunViewItem] = [
        RunViewItem(name: "Time", runViewType: .timer),
        RunViewItem(name: "Distance", runViewType: .distance),
        RunViewItem(name: "Pace", runViewType: .pace),
        RunViewItem(name: "Heart Rate", runViewType: .heartRate),
    ]
    
    
    /** Location Manager */
    let manager = CLLocationManager()
    @Published var isAuthorized: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkStatus()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        checkStatus()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: update error handling
        NSLog("error retrieving locaiton")
    }
    func checkStatus() {
        if manager.authorizationStatus == .authorizedWhenInUse {
            isAuthorized = true
        } else if manager.authorizationStatus == .denied {
            isAuthorized = false
        }
    }
    
    
}

enum CurrentTimeFormat: String {
    case seconds = "s"
    case minutes = "m:ss"
    case hours = "h:mm:ss"
    
    mutating func updateTimeFormat(elapsedTime: Int) {
        if elapsedTime < 60000 {
            self = .seconds
        } else if elapsedTime < 3600000 {
            self = .minutes
        } else {
            self = .hours
        }
    }
            
//    func getFormatter() -> String {
//        switch self {
//        case .seconds:
//            return "s"
//        case .minutes:
//            return "m:ss"
//        case .hours:
//            return "h:mm:ss"
//        }
//    }
}
