//
//  HeartRateLine.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/9/23.
//

import Foundation
import SwiftUI

struct HeartRateLine: View {
    @Binding var zone: Int?
    var label: String
    
    var body: some View {
        HStack {
            Text("\(label): ")
            TextField("Bottom of \(label)", value: $zone, format: .number)
                .keyboardType(.numberPad)
        }
    }
}
