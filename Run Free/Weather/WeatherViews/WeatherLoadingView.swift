//
//  WeatherLoadingView.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/25/23.
//

import Foundation
import SwiftUI

struct WeatherLoadingView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "clock.arrow.circlepath")
                .imageScale(.large)
                .font(.largeTitle)
            Text("Loading Weather")
        }
            
    }
}
