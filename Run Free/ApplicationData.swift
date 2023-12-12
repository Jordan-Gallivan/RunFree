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
    
    /// Navigation Path
    @Published var viewPath = NavigationPath()
    
    
    /// Edit Components
    @Published var selectedComponentToEdit: RunComponentModel? = nil
    
    /// Run View Components
    @Published var timerActive: Bool = false
    @Published var timerPaused: Bool = false
    
    /// Heart Rate
    @Published var heartRate: Int = 0
    
    // MARK: - Elapsed Timer
    @Published var timer: Timer? = nil
    @Published var elapsedTime: Int = 0  // milliseconds
    @Published var currentTimeFormat: CurrentTimeFormat = .seconds
    
    // MARK: - Elapsed Distance
    private var prevLocation: CLLocation?
    private var currentLocation: CLLocation?
    private var elapsedDistanceInMeters: Double = 0
    func elapsedDistance(isMetric: Bool) -> Double {
        return isMetric ? self.elapsedDistanceInMeters / 1000.0 : self.elapsedDistanceInMeters / 1609.34
    }
    
    // MARK: - Pace
    private var distanceFiveSecondsAgo: Double = 0
    var paceSecondsPerMeter: Double = 0 // seconds per meter
    func pace(metric: Bool) -> Int { 
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
    
    // MARK: - Location Manager
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

}
