//
//  ParsedWeather.swift
//  Run Free
//
//  Created by Jordan Gallivan on 12/14/23.
//

import Foundation

struct ParsedWeather {
    let weatherCondition: [WeatherCondition]?
    let windDirection: String?
    let windSpeed: Int?
    let clouds: Clouds?
    let temperature: Int?
}
