//
//  RunViewItem.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/16/23.
//

import Foundation
import SwiftUI

/// Displays Run Component with title and Component.  Determines which component to display
struct RunComponentView: View, Identifiable, Hashable {
    // Identifiable Protocol
    var anyHashableID: AnyHashable {
        AnyHashable(self.name)
    }
    var id: UUID = UUID()
    
    var name: String
    var isTitleVisible: Bool
    var componentSize: CGFloat
    var componentColor: Color
    var runComponentType: RunComponentType

    var body: some View {
        
        ZStack {
            if isTitleVisible {
                Text(name)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Group {
                switch runComponentType {
                case .timer:
                    RunningTimerView(name: name, componentSize: componentSize, componentColor: componentColor)
                case .distance:
                    DistanceView(name: name, componentSize: componentSize, componentColor: componentColor)
                case .pace:
                    PaceView(name: name, componentSize: componentSize, componentColor: componentColor)
                case .heartRate:
                    HeartRateView(name: name, componentSize: componentSize, componentColor: componentColor)
                case .zones:
                    ZoneView()
                }
            }
            .frame(maxWidth: .infinity, alignment: isTitleVisible ? .leading : .center)
            .padding([.leading], isTitleVisible ? 100 : 0)
        }
    }
    
    init(runViewComponent component: RunComponentModel) {
        self.name = component.name
        self.isTitleVisible = component.isTitleVisible
        self.componentSize = component.componentSize
        self.componentColor = component.componentColor.color
        self.runComponentType = component.runComponentType
    }
}

extension HorizontalAlignment {
    private enum CenterRunComponent: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }
    static let centerRunComponent = HorizontalAlignment(CenterRunComponent.self)
}



