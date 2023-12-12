//
//  RunComponent.swift
//  Run Free
//
//  Created by Jordan Gallivan on 12/4/23.
//

import Foundation
import SwiftData
import SwiftUI

/// Model class to store user defined settings for each Run Component View
@Model
final class RunComponentModel: Identifiable {
    // MARK: - Identifiable
    var id: UUID = UUID()
    var name: String = ""
    
    // MARK: - Component Properties
    @Attribute(.unique) var position: Int
    var isVisible: Bool = true
    var componentSize: CGFloat = 0.0
    
    // Computed property to avoid overlap of title and component
    private var isTitleVisiblePrivate: Bool = true
    var isTitleVisible: Bool {
        get { isTitleVisiblePrivate && componentSize < 60 }
        set { isTitleVisiblePrivate = newValue }
    }
    
    // Computed property in response to inability to use Color with SwiftData
    var componentColorString: String = "primary"
    var componentColor: ColorEnum { ColorEnum(rawValue: componentColorString)! }
    
    // Computed property in response to inability to use Enum with SwiftData
    private var runComponentTypeRawValue: String
    var runComponentType: RunComponentType { RunComponentType(rawValue: runComponentTypeRawValue)! }
    
    init(name: String,
         position: Int,
         isVisible: Bool,
         isTitleVisible: Bool,
         componentSize: CGFloat,
         runComponentType: RunComponentType) {
        self.name = name
        self.position = position
        self.isVisible = isVisible
        self.isTitleVisiblePrivate = isTitleVisible
        self.componentSize = componentSize
        self.runComponentTypeRawValue = runComponentType.rawValue
    }
}
