//
//  DefaultRunComponents.swift
//  Run Free
//
//  Created by Jordan Gallivan on 12/4/23.
//

import Foundation

/// On initial application install, these default components are stored for display in the Run View.
let DEFAULT_RUN_COMPONENTS: [RunComponentModel] = [
    RunComponentModel(name: "Time",
                 position: 0,
                 isVisible: true,
                 isTitleVisible: true,
                 componentSize: CGFloat(54),
                 runComponentType: RunComponentType.timer),
    RunComponentModel(name: "Distance",
                 position: 1,
                 isVisible: true,
                 isTitleVisible: true,
                 componentSize: CGFloat(24),
                 runComponentType: RunComponentType.distance),
    RunComponentModel(name: "Pace",
                 position: 2,
                 isVisible: true,
                 isTitleVisible: true,
                 componentSize: CGFloat(24),
                 runComponentType: RunComponentType.pace),
    RunComponentModel(name: "Heart Rate",
                 position: 3,
                 isVisible: true,
                 isTitleVisible: true,
                 componentSize: CGFloat(24),
                 runComponentType: RunComponentType.heartRate),
    RunComponentModel(name: "Zone",
                 position: 4,
                 isVisible: true,
                 isTitleVisible: false,
                 componentSize: CGFloat(24),
                 runComponentType: RunComponentType.zones),
]
