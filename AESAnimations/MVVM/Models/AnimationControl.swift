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

    var speed: Speed = .normal
    var direction: Direction = .normal
    
    var plusTriggered = false
    var minusTriggered = false
    
    // Continue / Pause animation
    mutating func changePause(to value: Bool) { isPaused = value }
     
    mutating func handleAnimation(direction: Direction) {
        isPaused = false
        
        if self.direction != direction {
            self.direction = direction
            speed = .normal
        } else {
            updateSpeed()
        }
    }
    
    mutating func updateSpeed() {
        switch speed {
        case .normal:
            speed = .double
        case .double:
            speed = .triple
        case .triple:
            speed = .normal
            direction = .normal
        }
    }
    
    mutating func resetAnimationFlags() {
        isPaused = true
        direction = .normal
        speed = .normal
    }
}
