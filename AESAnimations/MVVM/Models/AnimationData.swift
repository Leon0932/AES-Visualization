//
//  AnimationData.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 10/29/24.
//

import SwiftUI

struct AnimationData: Identifiable {
    let id = UUID()
    var animationTask: Task<Void, Never>? = nil
    var animationSteps: [AnimationStep] = []
    var reverseAnimationSteps: [AnimationStep] = []
}
