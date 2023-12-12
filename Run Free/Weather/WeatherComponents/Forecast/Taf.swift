//
//  Taf(revised).swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/2/23.
//

import Foundation

/// Parses and Stores the Weather information for a Terminal Aerodrome Forecast (TAF) .
class Taf {
    
    var forecasts: [Forecast] = []
    private var currentTime = -1    // integer reference value
    private var currentDate = 0     // integer reference value
    private var currentDateObject: Date // Date object, rounded floor(hour)
    private var currentTimeInSeconds: TimeInterval  // time interval in seconds of currentDateObject
    
    private enum ComponentOptions {
        case wind, vis, precip, cloud, other
    }
    
    required init(weatherString: String,
                  forecastDuration: Int = 5,
                  sunriseSunsetToday: SunriseSunsetDateObject,
                  sunriseSunsetTomorrow: SunriseSunsetDateObject,
                  startTimeOfDay: TimeOfDay) throws {
        // initialize current date and time
        let date = Date()
        let timeFormat = DateFormatter()
        timeFormat.timeZone = TimeZone(abbreviation: "UTC")
        timeFormat.dateFormat = "HHmm"
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd"
        currentTime = Int(timeFormat.string(from: date))!
        currentDate = Int(dateFormat.string(from: date))!
        currentDateObject = Date(timeIntervalSinceReferenceDate: (date.timeIntervalSinceReferenceDate / 3600).rounded(.toNearestOrEven) * 3600)
        currentTimeInSeconds = currentDateObject.timeIntervalSinceReferenceDate
        
        var timeOfDay = startTimeOfDay
        var currentSunriseSunset = sunriseSunsetToday
        
        // initialize forecasts array
        let initTime = (currentTime / 100) * 100
        
        // initialize forecasts array with times and sunrise/sunset lines (if applicable)
        for i in 0...forecastDuration {
            // increment forecast time and date object
            let forecastTime = initTime + (i * 100)
            let timeInterval = TimeInterval(i * 3600)
            let dateObject = Date(timeIntervalSinceReferenceDate: currentTimeInSeconds + timeInterval)
            
            // determine if sunrise/sunset line
            if dateObject > currentSunriseSunset.sunsetDateObject && timeOfDay == .day {
                forecasts.append(Forecast (
                    date: Int(dateFormat.string(from: currentSunriseSunset.sunsetDateObject))!,
                    time: Int(timeFormat.string(from: currentSunriseSunset.sunsetDateObject))!,
                    sunset: true,
                    dateObject: currentSunriseSunset.sunsetDateObject
                ))
                timeOfDay = .postSunSet
            } else if dateObject > currentSunriseSunset.sunriseDateObject && timeOfDay == .preSunrise {
                forecasts.append(Forecast (
                    date: Int(dateFormat.string(from: currentSunriseSunset.sunriseDateObject))!,
                    time: Int(timeFormat.string(from: currentSunriseSunset.sunriseDateObject))!,
                    sunrise: true,
                    dateObject: currentSunriseSunset.sunriseDateObject
                ))
                timeOfDay = .day
            }
            
            // update time of day if a sunrise/sunset line was passed
            let night = timeOfDay == .preSunrise || timeOfDay == .postSunSet
            forecasts.append(Forecast(
                date: forecastTime < 2400 ? currentDate : currentDate + 1,
                time:  forecastTime < 2400 ? forecastTime : forecastTime - 2400,
                night: night,
                dateObject: dateObject
            ))
            
            // increment day if end of day reached
            if forecastTime > 2400 {
                timeOfDay = .preSunrise
                currentSunriseSunset = sunriseSunsetTomorrow
            }
            
        }
        
        // alternate background colors
        for i in 0..<forecasts.count {
            if i % 2 == 0 {
                forecasts[i].backgroundColor = .secondary.opacity(0.2)
            }
        }
        
        // break taf into individual lines
        var lines = weatherString.split(separator: "\n").map { String($0) }
        
        // TODO: valid taf call
        
        // Populate 0 index of forecasts array
        let tafLine = lines.remove(at: 0).split(separator: " ").map { String($0) }
        
        // find wind
        var i = 0
        while i < tafLine.count && tafLine[i].firstMatch(of: /KT$/) == nil {
            i += 1
        }
        
        // ensure taf is readable (has a wind component that was found)
        guard i < tafLine.count else {
            NSLog("Invalid tafline.  No wind component. \(tafLine)")
            throw TafError.runTimeError(message: "Invalid tafline.  No wind component. \(tafLine)")
        }
        
        // populate all forecast elements with top line of TAF
        updateForecastsFromIndicies(components: Array(tafLine[i...]), startIndex: 0, endIndex: forecasts.count)
        
        // parse remainder of TAF
        parseTaf(tafLines: lines)
        
    }
    
    private func determineValidTaf(line: String, currentDateTime: Date) -> Bool {
        let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: currentDateTime)
        
        guard let currentDay = calendarDate.day, let currentMonth = calendarDate.month, let currentYear = calendarDate.year else {
            NSLog("ERROR parsing current date")
            return false
        }
        
        let (_, startDateTimeString, endDateTimeString) = line.matches(of: TafForecastWindowMather)[0].output
        let startDay = Int(startDateTimeString[startDateTimeString.startIndex..<startDateTimeString.index(startDateTimeString.startIndex, offsetBy: 2)])
        let startTime = startDateTimeString[startDateTimeString.index(startDateTimeString.startIndex, offsetBy: 2)..<startDateTimeString.endIndex]
        
        let endDay = Int(endDateTimeString[endDateTimeString.startIndex..<endDateTimeString.index(endDateTimeString.startIndex, offsetBy: 2)])
        let endTime = endDateTimeString[endDateTimeString.index(endDateTimeString.startIndex, offsetBy: 2)..<endDateTimeString.endIndex]
        guard let startDay, let endDay else {
            NSLog("ERROR PARSING DAYS")
            return false
        }
        
        var startMonth, endMonth, startYear, endYear: Int
        
        if currentDay == startDay || currentDay == 1 && startDay == 2 {
            // start of taf occurs in same month
            startMonth = currentMonth
            startYear = currentYear
            
            endMonth = startMonth
            endYear = startYear
            // determine if endDay is in another month (occurs before startDay)
            if endDay - startDay < 0 {
                endMonth += 1
                // end month is at start of next year
                if endMonth > 12 {
                    endMonth = 1
                    endYear += 1
                }
            }
        } else {
            // start of taf occurs in previous month
            startMonth = currentMonth - 1
            startYear = currentYear
            if startMonth < 1 {
                startMonth = 12
                startYear -= 1
            }
            // start on 31, end on 1 -> end - start < 0     *** end is in current month/year
            // start on 30, end on 31 -> end - start >= 0   *** occur in same month/year (taf expired)
            endMonth = startMonth
            endYear = startYear
            if endDay - startDay < 0 {
                endMonth = currentMonth
                endYear = currentYear
            }
        }
        let startDayString = padwithZeros(string: String(startDay), length: 2)
        let startDayMonth = padwithZeros(string: String(startMonth), length: 2)
        let endDayString = padwithZeros(string: String(endDay), length: 2)
        let endDayMonth = padwithZeros(string: String(endMonth), length: 2)
        
        let start = "\(startDayString)\(startDayMonth)\(startYear)\(startTime)"
        let end = "\(endDayString)\(endDayMonth)\(endYear)\(endTime)"
        
        let dateTimeFormat = DateFormatter()
        dateTimeFormat.timeZone = TimeZone(abbreviation: "UTC")
        dateTimeFormat.dateFormat = "ddMMyyyyHH"
        
        guard let startDateTime = dateTimeFormat.date(from: start), let endDateTime = dateTimeFormat.date(from: end) else {
            NSLog("ERROR Converting to dateTime from string")
            return false
        }
        
        return currentDateTime <= endDateTime
    }
    
    private func padwithZeros(string: String, length: Int) -> String {
        var str = string
        while str.count < length {
            str = "0" + str
        }
        return str
    }
    
    
    /// Parses a TAF into its wind, precipitation, and sky condition (clouds) components if they exist on that line.
    ///
    ///- Parameter tafLines: Array of TAF lines.
    private func parseTaf<T: Sequence>(tafLines lines: T) where T.Iterator.Element == String {
        
        // iterate over the TAF Lines
        for line in lines {
            let components = line.split(separator: /\s/).map { String($0) }
            
            // Parse TAF Line qualifier (TEMP, PROB, BECMG, or FROM)
            let (_, change, dateTime) = components[0].matches(of: TafQualifierMatcher)[0].output
            
            
            var startTime, startDate: Int
            var endTime, endDate: Int?
            var probability: Int?
            
            var i = 1
            
            // Determine TAF Line qualifier if one exists
            switch change {
            case TafChanges.BECMG.rawValue:
                (startDate, startTime) = parseDateTime(dateTimeString: components[1].split(separator: "/").map { String($0) }[0])
                i += 1
            case TafChanges.FM.rawValue:
                (startDate, startTime) = parseDateTime(dateTimeString: String(dateTime))
            case TafChanges.PROB.rawValue:
                probability = Int(dateTime)
                fallthrough
            case TafChanges.TEMPO.rawValue:
                let datesAndTimes = components[1].split(separator: "/").map { String($0) }
                (startDate, startTime) = parseDateTime(dateTimeString: datesAndTimes[0])
                (endDate, endTime) = parseDateTime(dateTimeString: datesAndTimes[1])
                i += 1
            default:
                continue
            }
            
            // Continue parsing components and update applicable forecasts
            updateForecasts(components: Array(components[i..<components.count]),
                            startTime: startTime,
                            startDate: startDate,
                            endTime: endTime,
                            endDate: endDate,
                            probability: probability)
        }
    }
    
    /// Parses the date and time from a given string from the following two formats: ddHH or ddHHmm
    ///
    /// - Parameter dateTimeString: date time string in one of the following formats: ddHH or ddHHmm
    ///
    /// - Returns: (date, time) where time is in the 24-Hour format, HHmm.
    private func parseDateTime(dateTimeString string:String) -> (Int, Int) {
        let dateIndex = string.index(string.startIndex, offsetBy: 2)
        var date = Int(string[..<dateIndex])!
        var timeString = string[dateIndex...]
        
        if timeString.count == 2 {
            timeString += "00"
        }
        
        var time = (Int(timeString)! / 100) * 100
        if time == 2400 {
            date += 1
        }
        if time >= 2400 {
            time -= 2400
        }
        
        return (date, time )
    }
    
    /// Continues Parsing the TAF Line into its wind, precipitation, and sky condition (clouds) components.  Then Updates the forecasts startDate/Time <= forecast < endDate/Time.
    ///
    ///- Parameters:
    ///   - components: TAF string to be parsed.
    ///   - startTime: Inclusive Starting time of the forecast in 24-Hour Format, rounded down to the nearest hour.  Example 1500
    ///   - startDate: Inclusive Starting date of the forecast.  Example 11
    ///   - endTime: Optional NOT Inclusive Ending time of the forecast in 24-Hour Format, rounded down to the nearest hour.  Example 2100.  If none is provided, all forecasts after the starting date/time are updated.
    ///   - startDate: Inclusive Ending Date of the forecast.  Example 12. If none is provided, all forecasts after the starting date/time are updated.
    ///   - probability: Optional probability qualifier for the forecast.
    private func updateForecasts(components: [String], startTime: Int, startDate: Int, endTime: Int?, endDate: Int?, probability: Int? = nil) {
        // indicies for start(inclusive) and end(not inclusive) of forecasts array to be updated
        var i = 0
        var j = 0
        
        // if forecast is on an interval (has an end time/date)
        if let endDate, let endTime {
            // index into array until forecasts[i].date == startDate and forecasts[i].time >= startTime
            while i < forecasts.count
                    && ((forecasts[i].date != startDate || forecasts[i].time < startTime) || (startDate == 1 && forecasts[i].date >= 28)) {
                
                i += 1
                // TODO: Fix while conditional for end of the month...
            }
            guard i < forecasts.count else {
                return
            }
            
            j = i
            
            // index into array until forecasts[i].date == endDate and forecasts[i].time == endTime
            while j < forecasts.count && (forecasts[j].date != endDate || forecasts[j].time != endTime) {
                j += 1
            }
            
            // verify valid end date/time
            guard i != j else {
                return
            }
            // forecast is from or becoming
        } else {
            // index into array until start date/time is before or equal to forecasts[i]
            while i < forecasts.count
                    && ((forecasts[i].date != startDate || forecasts[i].time < startTime) || (startDate == 1 && forecasts[i].date >= 28)) {
                
                i += 1
                // TODO: Fix while conditional for end of the month...
            }
            
            // vefify start date/time within the array
            guard i < forecasts.count else {
                return
            }
            j = forecasts.count
        }
        
        updateForecastsFromIndicies(components: components, startIndex: i, endIndex: j, probability: probability)
        
    }
    
    /// Parses the TAF Line into its componenets and updates the forecasts array.
    /// - Parameters:
    ///    - components: TAF string to be parsed.
    ///    - startIndex: Starting index for the first time of the forecast.
    ///    - endIndex: Last index the forecast is valid for (NOT inclusive).
    ///    - probability: Optional probabily to be included with the forecast
    ///
    private func updateForecastsFromIndicies(components comp: [String], startIndex: Int, endIndex: Int, probability: Int? = nil) {
        
        let (precipitation, windDirection, windSpeed, clouds, _) = WeatherParser.parseWeather(weather: comp)
        
        // update forecasts
        for k in startIndex..<endIndex {
            // only update if forecast line is NOT a sunrise/sunset time
            if !forecasts[k].sunrise && !forecasts[k].sunset {
                forecasts[k].windDirection = windDirection ?? forecasts[k].windDirection
                forecasts[k].windSpeed = windSpeed ?? forecasts[k].windSpeed
                forecasts[k].weatherCondition = precipitation ?? forecasts[k].weatherCondition
                forecasts[k].clouds = clouds ?? forecasts[k].clouds
                forecasts[k].probability = probability ?? forecasts[k].probability
            }
        }
    }
    
    enum TafError: Error {
        case runTimeError(message: String)
    }
}
