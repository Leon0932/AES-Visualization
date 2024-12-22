//
//  AnimationData.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 10/29/24.
//

import SwiftUI

/// Data Structure to save data for the Animations
/// including steps for- and backwards animations and a task
struct AnimationData: Identifiable {
    let id = UUID()
    var animationTask: Task<Void, Never>? = nil
    var animationSteps: [AnimationStep] = []
    var reverseAnimationSteps: [AnimationStep] = []
}
