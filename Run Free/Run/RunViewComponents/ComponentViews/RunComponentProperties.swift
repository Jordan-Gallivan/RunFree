//
//  RunComponentProperties.swift
//  Run Free
//
//  Created by Jordan Gallivan on 12/4/23.
//

import Foundation
import SwiftUI

/// Defines the user definable settings for editable components
protocol RunComponentProperties {
    var name: String { get set }
    var componentSize: CGFloat { get set }
    var componentColor: Color { get set}
}
