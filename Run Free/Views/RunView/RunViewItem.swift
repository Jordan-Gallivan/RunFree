//
//  RunViewItem.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/16/23.
//

import Foundation
import SwiftUI

struct RunViewItem: View, Identifiable, Hashable {
    // internal variables for computed properties
    let runViewType: RunViewType
    
    // Identifiable Protocol
    var anyHashableID: AnyHashable {
        AnyHashable(self.name)
    }
    var id: UUID = UUID()
    
    var isVisible: Bool = true
    
    
    // RunViewItem Protocol
    var name: String
    var visible: Bool = false
    var body: some View {
        HStack {
            switch runViewType {
            case .timer:
                RunningTimer()
            case .distance:
                Distance()
            case .pace:
                Pace()
            case .heartRate:
                HeartRate()
            }
        }
    }
    
    init(name: String, runViewType: RunViewType) {
        self.name = name
        self.runViewType = runViewType
    }
}

struct DisplayLine<Content: View>: View {
    
    var name: String
    let content: () -> Content
    
    init(name: String, @ViewBuilder content: @escaping ()-> Content) {
        self.name = name
        self.content = content
    }
    
    var body: some View {
        ZStack {
            HStack{
                Text(name)
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                content()
                    .frame(maxWidth: .infinity, alignment: .leading)
//                Spacer()
            }
            .frame(maxWidth: .infinity)
            
//            HStack {
//                Spacer()
//                content()
//                Spacer()
//            }
        }
    }
}

enum RunViewType {
    case timer
    case distance
    case pace
    case heartRate
}

