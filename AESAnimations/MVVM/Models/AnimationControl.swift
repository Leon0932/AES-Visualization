//
//  AnimationController.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 13.09.24.
//

import SwiftUI

struct AnimationControl {
    var animationHasStarted = false
    var isDone = false
    var isPaused = false
    var isForward = false
    var isBackward = false
    var isDouble = false
    
    var plusTriggered = false
    var minusTriggered = false
    
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
