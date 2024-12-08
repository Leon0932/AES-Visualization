//
//  PrimaryColor.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import SwiftUI

/// Colors used throughout the app, configurable via the settings
enum PrimaryColor: String, CaseIterable, Codable {
    case red, orange, green, blue, purple, cyanBlue, pink

    var color: Color {
        switch self {
        case .red:
            return Color(PlatformColor(red: 0.707, green: 0.149, blue: 0, alpha: 1.0))
        case .orange:
            return Color(PlatformColor.orange)
        case .green:
            return Color(PlatformColor(red: 0, green: 0.490, blue: 0, alpha: 1.0))
        case .blue:
            return Color(PlatformColor(red: 0.017, green: 0.392, blue: 1.0, alpha: 1.0))
        case .purple:
            return Color(PlatformColor(red: 0.579, green: 0.259, blue: 0.579, alpha: 1.0))
        case .cyanBlue:
            return Color(PlatformColor(red: 0.25, green: 0.72, blue: 0.87, alpha: 1.0))
        case .pink:
            return Color(PlatformColor(red: 1.00, green: 0.46, blue: 0.76, alpha: 1.0))
        }
    }
}
