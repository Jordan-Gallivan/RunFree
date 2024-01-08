//
//  WeatherFetch.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/1/23.
//

import Foundation

/// Weather Components accessable through FetchWeather
struct Weather {
    var metar: Metar
    var metarDistance: Double
    var taf: Taf
    var tafDistance: Double
    var sunrise: Date
    var sunset: Date
}

/// Fetches current and forecast weather based on user's current location
@MainActor
class FetchWeather: ObservableObject {
    
    @Published var result: AsyncResult<Weather> = .empty
    @Published var weather: Weather? = nil
    
    enum WeatherViewError: Error {
        case runTimeError(message: String)
    }
    
    func reload() async {
        self.result = .inProgress
        
        // TODO: update lat/long from user
        let userLat = 30.1
        let userLong = -91.75
                
        do {
            // fetch sunrise/sunset
            let (sunriseSunsetToday, sunriseSunsetTomorrow) = try await fetchSunriseSunset(userLatitude: userLat, userLongitude: userLong)
            
            let timeOfDay = determineTimeOfDay(sunriseSunset: sunriseSunsetToday, currentTime: Date())
            
            // fetch nearest stations (airports)
            let stations = try await fetchAirports(userLatitude: userLat, userLongitude: userLong)
            guard let stations else {
                throw WeatherViewError.runTimeError(message: "error fetching stations")
            }
            
            // fetch current weather (metar)
            let (metar, metarDistance) = try await fetchMetar(stations: stations, night: timeOfDay != .day)
            
            // fetch forecast (taf)
            let (taf, tafDistance) = try await fetchTaf(stations: stations, sunriseSunsetToday: sunriseSunsetToday, sunriseSunsetTomorrow: sunriseSunsetTomorrow, timeOfDay: timeOfDay)
            // TODO: how to use distance
            
            guard let taf, let tafDistance else {
                throw WeatherViewError.runTimeError(message: "error fetching taf")
            }
            self.weather = Weather(metar: metar,
                                   metarDistance: metarDistance,
                                   taf: taf,
                                   tafDistance: tafDistance,
                                   sunrise: sunriseSunsetToday.sunriseDateObject,
                                   sunset: sunriseSunsetToday.sunsetDateObject)
            self.result = .success(self.weather!)
            
        } catch {
            self.result = .failure(error)
        }
    }
    
    func determineTimeOfDay(sunriseSunset: SunriseSunsetDateObject, currentTime: Date) -> TimeOfDay {
        if currentTime < sunriseSunset.sunriseDateObject {
            return .preSunrise
        } else if currentTime > sunriseSunset.sunsetDateObject {
            return .postSunSet
        }
        return .day
    }
    
    
    /// URL Fetch helper method
    func fetch(url: String) async throws -> Data? {
        guard let requestUrl = URL(string: url) else {
            NSLog("Error with fetching url: \(url).")
            throw WeatherViewError.runTimeError(message: "Error with fetching url: \(url).")
        }
        
        let (data, response) = try await URLSession.shared.data(from: requestUrl)
        
        // TODO: add error handling
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            NSLog("error with fetching url: \(url).  HTTP Response: \(response)")
            throw WeatherViewError.runTimeError(message: "Error with fetching url: \(url).")
        }
        
        return data
        
    }
    
    /// Fetches all airports within a 40nm radius of the user.
    ///
    /// - Parameters:
    ///    - userLatitude: Decimal user latitude where North is positive, South is Negative.  Example 30.17 is N30.17
    ///    - userLongitude: Decimal user longitude where West is negative, and East is positive.  Example -81.6 is W81.6
    ///
    /// - Returns Minimum Heap of airports ordered by their distance to the user.  If no airports with METARs exist within 40nm of the user, returns nil.
    func fetchAirports(userLatitude: Double, userLongitude: Double) async throws -> PriorityQueue<Airport>? {
        var stations: PriorityQueue<Airport>? = nil
            
        let data = try await fetch(url: WeatherUrlConstants.GET_STATIONS_URL(userLatitude: userLatitude, userLongitude: userLongitude))
        
        guard let data = data else {
            NSLog("Error with fetching airports at latitude: \(userLatitude), longitude: \(userLongitude)")
            throw WeatherViewError.runTimeError(message: "Error with fetching airports at latitude: \(userLatitude), longitude: \(userLongitude)")
        }
        
        let parser = XMLParser(data: data)
        let delegate = StationParser(userLatitude: userLatitude, userLongitude: userLongitude)
        parser.delegate = delegate
        parser.parse()
        
        if !(delegate.stations?.isEmpty ?? true) {
            stations = delegate.stations!
        }
        
        return stations
    }
    
    /// Fetches the Meteorological Aerodrome Report (METAR) of the nearest airprot to the user that has a METAR.
    ///
    /// - Parameter stations: Minimum Heap of airports ordered by their distance to the user.
    /// - Returns (Metar Object, distance of that station to the user)
    func fetchMetar(stations: PriorityQueue<Airport>, night: Bool) async throws -> (Metar, Double) {
        var metar: Metar? = nil
        var distance: Double? = nil
        
        for station in stations {
            guard station.hasMetar else {
                continue
            }
            let data = try await fetch(url: "\(WeatherUrlConstants.METAR_URL_PREFIX)\(station.stationID)")
            if let data, let metarSting = String(data: data, encoding: .utf8), metarSting != "" {
                do {
                    metar = try Metar(weatherString: metarSting, night: night)
                } catch {
                    NSLog("Error fetching Metar for: \(station.stationID)")
                    continue
                }
                distance = station.distanceToUser
                break
            }
            
        }
        
        guard let metar, let distance else {
            NSLog("Error fetching Metar")
            throw WeatherViewError.runTimeError(message: "Error fetching Metar")
        }
        
        return (metar, distance)
    }
    
    /// Fetches the Terminal Aerodrome Forecast (TAF)  of the nearest airprot to the user that has a TAF.
    ///
    /// - Parameter stations: Minimum Heap of airports ordered by their distance to the user.
    /// - Returns (Taf Object, distance of that station to the user).  If no Airports with a TAF exist within 40nm of the user, returns nil.
    func fetchTaf(stations: PriorityQueue<Airport>,
                  sunriseSunsetToday: SunriseSunsetDateObject,
                  sunriseSunsetTomorrow: SunriseSunsetDateObject,
                  timeOfDay: TimeOfDay) async throws -> (Taf?, Double?) {
        var taf: Taf? = nil
        var distance: Double? = nil
        
        for station in stations {
            guard station.hasTaf else {
                continue
            }
            let data = try await fetch(url: "\(WeatherUrlConstants.TAF_URL_PREFIX)\(station.stationID)")
            if let data, let tafString = String(data: data, encoding: .utf8), tafString != "" {
                do {
                    try taf = Taf(weatherString: tafString, sunriseSunsetToday: sunriseSunsetToday, sunriseSunsetTomorrow: sunriseSunsetTomorrow, startTimeOfDay: timeOfDay)
                    distance = station.distanceToUser
                    break
                } catch {
                    NSLog("Error fetching TAF for: \(station.stationID)")
                    continue
                }
            }
            
        }
        guard let taf, let distance else {
            NSLog("Error fetching TAF")
            return (nil, nil)
        }
        
        return (taf, distance)
    }
    
    /// Fetches the sunrise and sunset data for the provided Latitude/Longitude for the current day and the following day (tomorrow).
    ///
    /// - Parameters:
    ///    - userLatitude: Decimal user latitude where North is positive, South is Negative.  Example 30.17 is N30.17
    ///    - userLongitude: Decimal user longitude where West is negative, and East is positive.  Example -81.6 is W81.6
    ///
    ///  - Returns: Tuple of SunriseSunsetDate objects for today and tomorrow (today's sunrise/sunset, tomorrow's sunrise/sunset)
    func fetchSunriseSunset(userLatitude: Double, userLongitude: Double) async throws -> (SunriseSunsetDateObject, SunriseSunsetDateObject) {
        let dataToday = try await fetch(url: WeatherUrlConstants.GET_TODAY_SUNRISE_SUNSET_URL(userLatitude: userLatitude, userLongitude: userLongitude))
        let dataTomorrow = try await fetch(url: WeatherUrlConstants.GET_TOMORROW_SUNRISE_SUNSET_URL(userLatitude: userLatitude, userLongitude: userLongitude))
        
        guard let dataToday, let dataTomorrow else {
            NSLog("Error fetching sunrise/sunset")
            throw WeatherViewError.runTimeError(message: "error fetching sunrise/sunset")
        }
        let sunriseSunsetParserToday: SunriseSunsetParser = try! JSONDecoder().decode(SunriseSunsetParser.self, from: dataToday)
        let sunriseSunsetParserTomorrow: SunriseSunsetParser = try! JSONDecoder().decode(SunriseSunsetParser.self, from: dataTomorrow)
        
        guard sunriseSunsetParserToday.status == .OK && sunriseSunsetParserTomorrow.status == .OK else {
            NSLog("Error fetching sunrise/sunset")
            throw WeatherViewError.runTimeError(message: "Error fetching sunrise/sunset")
        }
        
        return (SunriseSunsetDateObject(sunriseSunset: sunriseSunsetParserToday.results), SunriseSunsetDateObject(sunriseSunset: sunriseSunsetParserTomorrow.results))
    }
    
}
