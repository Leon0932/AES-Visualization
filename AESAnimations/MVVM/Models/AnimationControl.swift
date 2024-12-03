//
//  AnimationController.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 13.09.24.
//

import SwiftUI

struct AnimationControl {
    enum Speed {
        case normal
        case isDouble
        case isTriple
    }
    
    var animationHasStarted = false
    var isDone = false
    var isPaused = false
    var isForward = false
    var isBackward = false
    var speed: Speed = .normal
    
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
        speed = .normal
    }
    
    private mutating func handleAnimation(isActive: inout Bool, opposite: inout Bool) {
        
        isPaused = false
        opposite = false
        
        if isActive {
            switch speed {
            case .normal:
                speed = .isDouble
            case .isDouble:
                speed = .isTriple
            case .isTriple:
                speed = .normal
                isActive = false
            }
        } else {
            isActive = true
            speed = .normal
        }
    }
    
}
