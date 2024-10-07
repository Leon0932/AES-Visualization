//
//  AnimationController.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 13.09.24.
//

import SwiftUI

struct AnimationControl {
    var isDone: Bool = false
    var isPaused: Bool = false
    var isForward: Bool = false
    var isBackward: Bool = false
    var isDouble: Bool = false
    
    // Continue / Pause animation
    mutating func changePause(to value: Bool) { isPaused = value }
    
    // Reverse the animation
    mutating func advanceAnimations() {
        var isForwardCopy = isForward
        var isBackwardCopy = isBackward
        
        handleAnimation(isActive: &isForwardCopy, opposite: &isBackwardCopy)
        
        isForward = isForwardCopy
        isBackward = isBackwardCopy
    }
    
    mutating func reverseAnimation() {
        var isForwardCopy = isForward
        var isBackwardCopy = isBackward
        
        handleAnimation(isActive: &isBackwardCopy, opposite: &isForwardCopy)
        
        isForward = isForwardCopy
        isBackward = isBackwardCopy
    }
    
    mutating func resetAnimationFlags() {
        isPaused = true
        isForward = false
        isBackward = false
        isDouble = false
    }
    
    private mutating func handleAnimation(isActive: inout Bool, opposite: inout Bool) {
        
        isPaused = false
        opposite = false
        
        if isActive {
            isDouble.toggle()
            if !isDouble {
                isActive = false
            }
        } else {
            isActive = true
            isDouble = false
        }
    }
    
}
