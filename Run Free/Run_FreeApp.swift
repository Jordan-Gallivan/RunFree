//
//  Run_FreeApp.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/12/23.
//

import SwiftUI

@main
struct Run_FreeApp: App {
    @StateObject private var appData = AppData()
    @StateObject private var controller = PolarController()
    @StateObject private var weatherData = FetchWeather()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appData)
                .environmentObject(controller)
                .environmentObject(weatherData)
        }
        .modelContainer(for: [RunComponentModel.self, SettingsModel.self])
    }
}
