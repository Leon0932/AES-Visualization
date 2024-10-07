//
//  PrimaryColor.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import SwiftUI

enum PrimaryColor: String, CaseIterable, Codable {
    case red, orange, yellow, green, blue, purple, cyanBlue, pink

    var color: Color {
        switch self {
        case .red:
            return Color(PlatformColor.red)
        case .orange:
            return Color(PlatformColor.orange)
        case .yellow:
            return Color(PlatformColor.yellow)
        case .green:
            return Color(PlatformColor.green)
        case .blue:
            return Color(PlatformColor.blue)
        case .purple:
            return Color(PlatformColor.purple)
        case .cyanBlue:
            return Color(PlatformColor(red: 0.25, green: 0.72, blue: 0.87, alpha: 1.0))
        case .pink:
            return Color(PlatformColor(red: 1.00, green: 0.46, blue: 0.76, alpha: 1.0))
        }
    }
}
