//
//  PositionType.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 06.10.24.
//

import SwiftUI

/// Determines whether to use one-dimensional or two-dimensional arrays of
/// `Position` for Animation Views.
enum PositionType {
    case oneD([Position])
    case twoD([[Position]])
}
