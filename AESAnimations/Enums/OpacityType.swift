//
//  OpacityType.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 06.10.24.
//

import SwiftUI

/// Determines whether to use one-dimensional or two-dimensional arrays of
/// `OpacityType` for Animation Views.
enum OpacityType {
    case oneD([Double])
    case twoD([[Double]])
}

