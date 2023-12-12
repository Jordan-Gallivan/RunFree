//
//  ColorEnum.swift
//  Run Free
//
//  Created by Jordan Gallivan on 12/7/23.
//

import Foundation
import SwiftUI

/// Color Enum used to access context-dependent colors of SwiftUI in a Model
enum ColorEnum: String {
    case red
    case orange
    case yellow
    case green
    case mint
    case teal
    case cyan
    case blue
    case indigo
    case purple
    case pink
    case brown
    case white
    case gray
    case black
    case primary
    case secondary
    
    var color: Color {
        switch self {
        case .red:
            return Color.red
        case .orange:
            return Color.orange
        case .yellow:
            return Color.yellow
        case .green:
            return Color.green
        case .mint:
            return Color.mint
        case .teal:
            return Color.teal
        case .cyan:
            return Color.cyan
        case .blue:
            return Color.blue
        case .indigo:
            return Color.indigo
        case .purple:
            return Color.purple
        case .pink:
            return Color.pink
        case .brown:
            return Color.brown
        case .white:
            return Color.white
        case .gray:
            return Color.gray
        case .black:
            return Color.black
        case .primary:
            return Color.primary
        case .secondary:
            return Color.secondary
        }
    }
}

/// Context-dependent color options for use in Model.
let COLOR_OPTIONS = [
    "red",
    "orange",
    "yellow",
    "green",
    "mint",
    "teal",
    "cyan",
    "blue",
    "indigo",
    "purple",
    "pink",
    "brown",
    "white",
    "gray",
    "black",
    "primary",
    "secondary",
]
