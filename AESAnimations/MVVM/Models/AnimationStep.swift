//
//  AnimationStep.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 04.09.24.
//

import SwiftUI

/// A data structure for defining a single step in an animation sequence.
struct AnimationStep {
    let animation: @MainActor () async -> Void
    var delay: UInt64 = 0
}
