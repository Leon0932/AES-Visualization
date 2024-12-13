//
//  ProccessPhaseAnimation.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 05.10.24.
//

import SwiftUI

/// A helper structure for storing information about the current phase
/// of the cipher process in AES encryption or decryption.
///
/// Use case for `ProcessViewModel` to visualize the current phase of the AES algorithm,
/// whether for encryption or decryption.
struct ProcessPhaseAnimation {
    let index: Int
    let keyPath: KeyPath<CipherRound, [[Byte]]> /// Estimates the current round and determines the destination for the operation.
    let reverseKeyPath: KeyPath<CipherRound, [[Byte]]> /// Provides an option for reversing the animation.
    
    // For the View
    let operation: String
    let color: Color
}
