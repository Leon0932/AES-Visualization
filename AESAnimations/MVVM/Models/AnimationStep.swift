//
//  AnimationStep.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 04.09.24.
//

import SwiftUI

struct AnimationStep {
    let animation: @MainActor () async -> Void
    var delay: UInt64 = 0
}
