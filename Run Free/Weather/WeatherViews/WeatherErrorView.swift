//
//  WeatherErrorView.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/25/23.
//

import Foundation
import SwiftUI

struct WeatherErrorView: View {
    var body: some View {
        VStack{
            Image(systemName: "exclamationmark.triangle")
                .imageScale(.large)
                .font(.largeTitle)
            Text(errorMessage)
        }
    }
    var errorMessage: String
}
