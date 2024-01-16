//
//  Run_FreeTests.swift
//  Run FreeTests
//
//  Created by Jordan Gallivan on 10/12/23.
//

import XCTest
@testable import Run_Free

final class Run_FreeTests: XCTestCase {
    
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    /*
     let metars = [
         "abcdeavawfwefwfee",

         "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR FEW003 OVC048 02/02 A3049 RMK AO2 P0011 T00220017",

         "K19S 141535Z AUTO 14013KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",

         "KLHX 141541Z AUTO 00000KT 3/4SM -SN BR BKN004 OVC012 M01/M01 A3034 RMK AO2 P0000 T10061011",

         "KGCC 141453Z AUTO 17022G32KT 6SM BR CLR M01/M03 A3009 RMK AO2 PK WND 18032/1449 SLP221 T10111028 58014",

         "KIDA 141545Z 11004KT 1/4SM R21/1800V2200FT FZFG OVC002 M05/M07 A3033 RMK AO2 SNE30 P0000 T10501067",

         "KCDS 141453Z AUTO 10009G18KT 10SM -RA OVC023 06/03 A3040 RMK AO2 LTG DSNT W RAE29B45 SLP296 P0000 60001 T00560028 58005",

         "KGBD 141516Z AUTO 00000KT 4SM -RA BR BKN065 OVC080 03/03 A3054 RMK AO2 UPE07RAB07 P0001",

         "KGCK 141541Z 16008KT 4SM -RA BR BKN006 BKN036 OVC050 01/01 A3045 RMK AO2 RAE25B41SNB25E41 P0001 T00060006",
     ]
     */

    func testGoodWeatherConditionStrings() throws {
        let weatherString = "KDDC 141533Z AUTO 14010KT 2 1/2SM DZ RA SN SG IC PL GR GS TS VCTS TSRA TSSN TSPL TSGS TSGR SH VCHS SHRA SHSN SHPL SHGR SHGS FZDZ FZRA FZFG BR FG FU VA DU SA HZ BLSN BLSA BLDU PO FC FEW003 OVC048 02/02 A3049 RMK AO2 P0011 T00220017"
        let goodWeatherConditions: Set<WeatherCondition> = [
            WeatherCondition("Drizzile", "rain", .cloudAndSun),
            WeatherCondition("Rain", "rain", .cloudAndSun),
            WeatherCondition("Snow", "snow", .cloud),
            WeatherCondition("Snow Grains", "snow", .cloudOrSun),
            WeatherCondition("Ice Crystals", "snow", .cloudOrSun),
            WeatherCondition("Ice Pelelts", "snow", .cloudOrSun),
            WeatherCondition("Hail", "hail", .cloud),
            WeatherCondition("Small Hail", "hail", .cloud),
            WeatherCondition("Thunderstorm", "bolt.custom", .cloudAndSun),
            WeatherCondition("Thunderstorm", "bolt.custom", .cloudAndSun),
            WeatherCondition("Thunderstorm and Rain", "bolt.rain.custom", .cloud),
            WeatherCondition("Thunderstorm and Snow", "bolt.custom", .cloud),
            WeatherCondition("Thunderstorm and Ice Pellets", "bolt.custom", .cloud),
            WeatherCondition("Thunderstorm and Snow Grains", "bolt.custom", .cloud),
            WeatherCondition("Thunderstorm and Hail", "bolt.custom", .cloud),
            WeatherCondition("Showers", "rain", .cloudAndSun),
            WeatherCondition("Showers", "heavyrain", .cloud),
            WeatherCondition("Rain Showers", "heavyrain", .cloud),
            WeatherCondition("Snow Showers", "snow", .cloudOrSun),
            WeatherCondition("Showers of Ice Pellets", "snow", .cloudOrSun),
            WeatherCondition("Hail Showers", "hail", .cloud),
            WeatherCondition("Small Hail Showers", "hail", .cloud),
            WeatherCondition("Freezing Drizzle", "snow", .cloudOrSun),
            WeatherCondition("Freezing Rain", "rain", .cloudAndSun),
            WeatherCondition("Freezing Fog", "fog", .cloud),
            WeatherCondition("Mist", "fog", .cloud),
            WeatherCondition("Fog", "fog", .cloud),
            WeatherCondition("Smoke", "fog", .cloud),
            WeatherCondition("Volcanic Ash", "fog", .cloud),
            WeatherCondition("Dust", "dust", .sun),
            WeatherCondition("Sand", "dust", .sun),
            WeatherCondition("Haze", "haze", .sun),
            WeatherCondition("Blowing Snow", "snow", .cloud),
            WeatherCondition("Blowing Sand", "fog", .cloud),
            WeatherCondition("Blowing Dust", "fog", .cloud),
            WeatherCondition("Sand/Dust Whirls", "tornado", .none),
            WeatherCondition("Funnel Cloud", "tornado", .none),
        ]
        
        let testParsedWeather = WeatherParser.parseWeather(weather: weatherString)
        
        let weatherConditions = try XCTUnwrap(testParsedWeather.weatherCondition)
        
        weatherConditions.forEach {
            XCTAssert(goodWeatherConditions.contains($0))
        }
    }
    
    func testBadWeatherConditionStrings() throws {
        let badWeatherString = "KDDC 141533Z AUTO 14010KT 2 1/2SM aDZ aRA aSN aSG aIC aPL aGR aGS aTS aVCTS aTSRA aTSSN aTSPL aTSGS aTSGR aSH aVCHS aSHRA aSHSN aSHPL aSHGR aSHGS aFZDZ aFZRA aFZFG aBR aFG aFU aVA aDU aSA aHZ aBLSN aBLSA aBLDU aPO aFC FEW003 OVC048 02/02 A3049 RMK AO2 P0011 T00220017"
        
        let testParsedWeather = WeatherParser.parseWeather(weather: badWeatherString)
        
        XCTAssertNil(testParsedWeather.weatherCondition)
    }
    
    func testHeavyWeatherConditionStrings() throws {
        let weatherString = "KDDC 141533Z AUTO 14010KT 2 1/2SM +DZ +RA +SN +SG +IC +PL +GR +GS +TS +VCTS +TSRA +TSSN +TSPL +TSGS +TSGR +SH +VCHS +SHRA +SHSN +SHPL +SHGR +SHGS +FZDZ +FZRA +FZFG +BR +FG +FU +VA +DU +SA +HZ +BLSN +BLSA +BLDU +PO +FC FEW003 OVC048 02/02 A3049 RMK AO2 P0011 T00220017"
        
        let goodWeatherConditions: Set<WeatherCondition> = [
            WeatherCondition("Heavy Drizzile", "rain", .cloudAndSun),
            WeatherCondition("Heavy Rain", "rain", .cloudAndSun),
            WeatherCondition("Heavy Snow", "snow", .cloud),
            WeatherCondition("Heavy Snow Grains", "snow", .cloudOrSun),
            WeatherCondition("Heavy Ice Crystals", "snow", .cloudOrSun),
            WeatherCondition("Heavy Ice Pelelts", "snow", .cloudOrSun),
            WeatherCondition("Heavy Hail", "hail", .cloud),
            WeatherCondition("Heavy Small Hail", "hail", .cloud),
            WeatherCondition("Heavy Thunderstorm", "bolt.custom", .cloudAndSun),
            WeatherCondition("Heavy Thunderstorm", "bolt.custom", .cloudAndSun),
            WeatherCondition("Heavy Thunderstorm and Rain", "bolt.rain.custom", .cloud),
            WeatherCondition("Heavy Thunderstorm and Snow", "bolt.custom", .cloud),
            WeatherCondition("Heavy Thunderstorm and Ice Pellets", "bolt.custom", .cloud),
            WeatherCondition("Heavy Thunderstorm and Snow Grains", "bolt.custom", .cloud),
            WeatherCondition("Heavy Thunderstorm and Hail", "bolt.custom", .cloud),
            WeatherCondition("Heavy Showers", "rain", .cloudAndSun),
            WeatherCondition("Heavy Showers", "heavyrain", .cloud),
            WeatherCondition("Heavy Rain Showers", "heavyrain", .cloud),
            WeatherCondition("Heavy Snow Showers", "snow", .cloudOrSun),
            WeatherCondition("Heavy Showers of Ice Pellets", "snow", .cloudOrSun),
            WeatherCondition("Heavy Hail Showers", "hail", .cloud),
            WeatherCondition("Heavy Small Hail Showers", "hail", .cloud),
            WeatherCondition("Heavy Freezing Drizzle", "snow", .cloudOrSun),
            WeatherCondition("Heavy Freezing Rain", "rain", .cloudAndSun),
            WeatherCondition("Heavy Freezing Fog", "fog", .cloud),
            WeatherCondition("Heavy Mist", "fog", .cloud),
            WeatherCondition("Heavy Fog", "fog", .cloud),
            WeatherCondition("Heavy Smoke", "fog", .cloud),
            WeatherCondition("Heavy Volcanic Ash", "fog", .cloud),
            WeatherCondition("Heavy Dust", "dust", .sun),
            WeatherCondition("Heavy Sand", "dust", .sun),
            WeatherCondition("Heavy Haze", "haze", .sun),
            WeatherCondition("Heavy Blowing Snow", "snow", .cloud),
            WeatherCondition("Heavy Blowing Sand", "fog", .cloud),
            WeatherCondition("Heavy Blowing Dust", "fog", .cloud),
            WeatherCondition("Heavy Sand/Dust Whirls", "tornado", .none),
            WeatherCondition("Heavy Funnel Cloud", "tornado", .none),
        ]
        
        let testParsedWeather = WeatherParser.parseWeather(weather: weatherString)
        
        let weatherConditions = try XCTUnwrap(testParsedWeather.weatherCondition)
        
        weatherConditions.forEach {
            XCTAssert(goodWeatherConditions.contains($0))
        }
    }
    
    func testLightWeatherConditionStrings() throws {
        let weatherString = "KDDC 141533Z AUTO 14010KT 2 1/2SM -DZ -RA -SN -SG -IC -PL -GR -GS -TS -VCTS -TSRA -TSSN -TSPL -TSGS -TSGR -SH -VCHS -SHRA -SHSN -SHPL -SHGR -SHGS -FZDZ -FZRA -FZFG -BR -FG -FU -VA -DU -SA -HZ -BLSN -BLSA -BLDU -PO -FC FEW003 OVC048 02/02 A3049 RMK AO2 P0011 T00220017"
        
        let goodWeatherConditions: Set<WeatherCondition> = [
            WeatherCondition("Light Drizzile", "rain", .cloudAndSun),
            WeatherCondition("Light Rain", "rain", .cloudAndSun),
            WeatherCondition("Light Snow", "snow", .cloud),
            WeatherCondition("Light Snow Grains", "snow", .cloudOrSun),
            WeatherCondition("Light Ice Crystals", "snow", .cloudOrSun),
            WeatherCondition("Light Ice Pelelts", "snow", .cloudOrSun),
            WeatherCondition("Light Hail", "hail", .cloud),
            WeatherCondition("Light Small Hail", "hail", .cloud),
            WeatherCondition("Light Thunderstorm", "bolt.custom", .cloudAndSun),
            WeatherCondition("Light Thunderstorm", "bolt.custom", .cloudAndSun),
            WeatherCondition("Light Thunderstorm and Rain", "bolt.rain.custom", .cloud),
            WeatherCondition("Light Thunderstorm and Snow", "bolt.custom", .cloud),
            WeatherCondition("Light Thunderstorm and Ice Pellets", "bolt.custom", .cloud),
            WeatherCondition("Light Thunderstorm and Snow Grains", "bolt.custom", .cloud),
            WeatherCondition("Light Thunderstorm and Hail", "bolt.custom", .cloud),
            WeatherCondition("Light Showers", "rain", .cloudAndSun),
            WeatherCondition("Light Showers", "heavyrain", .cloud),
            WeatherCondition("Light Rain Showers", "heavyrain", .cloud),
            WeatherCondition("Light Snow Showers", "snow", .cloudOrSun),
            WeatherCondition("Light Showers of Ice Pellets", "snow", .cloudOrSun),
            WeatherCondition("Light Hail Showers", "hail", .cloud),
            WeatherCondition("Light Small Hail Showers", "hail", .cloud),
            WeatherCondition("Light Freezing Drizzle", "snow", .cloudOrSun),
            WeatherCondition("Light Freezing Rain", "rain", .cloudAndSun),
            WeatherCondition("Light Freezing Fog", "fog", .cloud),
            WeatherCondition("Light Mist", "fog", .cloud),
            WeatherCondition("Light Fog", "fog", .cloud),
            WeatherCondition("Light Smoke", "fog", .cloud),
            WeatherCondition("Light Volcanic Ash", "fog", .cloud),
            WeatherCondition("Light Dust", "dust", .sun),
            WeatherCondition("Light Sand", "dust", .sun),
            WeatherCondition("Light Haze", "haze", .sun),
            WeatherCondition("Light Blowing Snow", "snow", .cloud),
            WeatherCondition("Light Blowing Sand", "fog", .cloud),
            WeatherCondition("Light Blowing Dust", "fog", .cloud),
            WeatherCondition("Light Sand/Dust Whirls", "tornado", .none),
            WeatherCondition("Light Funnel Cloud", "tornado", .none),
        ]
        
        let testParsedWeather = WeatherParser.parseWeather(weather: weatherString)
        
        let weatherConditions = try XCTUnwrap(testParsedWeather.weatherCondition)
        
        weatherConditions.forEach {
            XCTAssert(goodWeatherConditions.contains($0))
        }
    }
    
    func testWindDirections() throws {
        let windStrings = [
            "K19S 141535Z AUTO 00013KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 01513KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 02313KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 04513KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 06713KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 09013KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 11313KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 14013KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 15713KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 17013KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 20313KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 23013KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 24713KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 29013KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 29313KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 32013KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 33713KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 36013KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO VRB13KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 03013G25KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO /////KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            
        ]
        let goodWindStrings = [
            "North",
            "North",
            "North East",
            "North East",
            "East",
            "East",
            "South East",
            "South East",
            "South",
            "South",
            "South West",
            "South West",
            "West",
            "West",
            "North West",
            "North West",
            "North",
            "North",
            "Variable",
            "North East",
            "Variable",
        ]
        for (i, str) in windStrings.enumerated() {
            let parsedWeather = WeatherParser.parseWeather(weather: str)
            let testWindDirection = try XCTUnwrap(parsedWeather.windDirection)
            XCTAssertEqual(testWindDirection, goodWindStrings[i])
        }
    }
    
    func testBadWindString() throws {
        let badWindStrings = [
            "K19S 141535Z AUTO 00013K 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 00a013KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 0001KT 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
            "K19S 141535Z AUTO 2 1/2SM -SN BR OVC003 01/ A3045 RMK AO2 P0002 T0014////",
        ]
        for str in badWindStrings {
            let parsedWeather = WeatherParser.parseWeather(weather: str)
            XCTAssertNil(parsedWeather.windDirection)
            XCTAssertNil(parsedWeather.windSpeed)
        }
    }
    
    func testPredominantCloudCondition() throws {
        let cloudStrings = [
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR SKC 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR FEW001 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR SCT002 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR BKN003 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR OVC004 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR SKC FEW001 SCT002 BKN003 OVC004 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR SKC FEW001 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR SKC SCT002 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR SKC BKN003 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR SKC OVC004 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR FEW001 SCT002 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR FEW001 BKN003 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR FEW001 OVC004 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR SCT002 BKN003 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR SCT002 OVC004 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR BKN003 OVC004 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR CB010 02/02 A3049 RMK AO2 P0011 T00220017",
        ]
        let goodCloudConditions: [Clouds] = [
            .SKC,
            .FEW,
            .SCT,
            .BKN,
            .OVC,
            .OVC,
            .FEW,
            .SCT,
            .BKN,
            .OVC,
            .SCT,
            .BKN,
            .OVC,
            .BKN,
            .OVC,
            .OVC,
            .SKC,
        ]
        for (i, str) in cloudStrings.enumerated() {
            let parsedWeather = WeatherParser.parseWeather(weather: str)
            let cloud = try XCTUnwrap(parsedWeather.clouds)
            XCTAssertEqual(cloud, goodCloudConditions[i])
        }
    }
    
    func testBadClouds() throws {
        let badCloudString = [
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR SCK100 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR SK100 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR SC100 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR FE100 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR BK100 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR OV100 02/02 A3049 RMK AO2 P0011 T00220017",
            "KDDC 141533Z AUTO 14010KT 2 1/2SM RA BR BC100 02/02 A3049 RMK AO2 P0011 T00220017",
        ]
        for str in badCloudString {
            let parsedWeather = WeatherParser.parseWeather(weather: str)
            XCTAssertNil(parsedWeather.clouds)
        }
    }
    
   // TODO: temp good
    // TODO: temp bad
    
    

}
