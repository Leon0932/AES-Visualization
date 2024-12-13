//
//  AnimationController.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 13.09.24.
//

import SwiftUI

/// A data structure for managing and controlling the current animation,
/// including its progress and state.
struct AnimationControl {
    // MARK: - Properties
    var animationHasStarted = false
    var isDone = false
    var isPaused = false

    var speed: Speed = .normal
    var direction: Direction = .normal
    
    var plusTriggered = false
    var minusTriggered = false
    
    
    // MARK: - Helper Functions
    mutating func changePause(to value: Bool) { isPaused = value }
    
    
    /// Utility functions to modify the animation's direction or adjust its speed
    /// if the direction remains unchanged.
    /// - Parameter direction: The current direction of the animation.
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
