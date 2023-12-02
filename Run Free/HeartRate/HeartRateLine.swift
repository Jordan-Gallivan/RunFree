//
//  HeartRateLine.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/9/23.
//

import Foundation
import SwiftUI

struct HeartRateLine: View {
    @Binding var zoneBottom: Int?
    @Binding var zoneTop: Int?
    var label: String
    var zoneHasTop: Bool
    
    var body: some View {
        HStack {
            Text("\(label): ")
            TextField("", value: $zoneBottom, format: .number)
                .keyboardType(.numberPad)
            if zoneHasTop {
                Text("to")
                TextField("", value: $zoneTop, format: .number)
                    .keyboardType(.numberPad)
            } else {
                Text("+")
            }
        }
    }    
}
