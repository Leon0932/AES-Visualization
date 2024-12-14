//
//  TextStyles.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 14.12.24.
//

import SwiftUI

/// A helper struct to ensure consistent font sizes between iOS and macOS.
/// This is particularly important for maintaining uniformity in certain animations.
struct TextStyles {
    static let headline = Font.system(size: 17, weight: .semibold)
}
