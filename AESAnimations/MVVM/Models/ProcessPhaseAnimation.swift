//
//  ProccessPhaseAnimation.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 05.10.24.
//

import SwiftUI

struct ProcessPhaseAnimation {
    let index: Int
    let keyPath: KeyPath<CipherRound, [[Byte]]>
    let reverseKeyPath: KeyPath<CipherRound, [[Byte]]>
    
    let operation: String
    let color: Color
}
