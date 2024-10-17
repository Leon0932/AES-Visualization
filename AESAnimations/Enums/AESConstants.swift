//
//  AESConstants.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 30.07.24.
//

import Foundation

enum AESConstants {
    static let generator: Byte = 3
    static let irreduciblePolynomial: Byte = 0x1b
    static let affineConstant: Byte = 0x63
    
    static let mixColumnMatrix: [[Byte]] = [
        [2, 3, 1, 1],
        [1, 2, 3, 1],
        [1, 1, 2, 3],
        [3, 1, 1, 2]
    ]
    
    static let invMixColumnMatrix: [[Byte]] = [
        [14, 11, 13, 9],
        [9, 14, 11, 13],
        [13, 9, 14, 11],
        [11, 13, 9, 14]
    ]
    
    static let rcon: [[Byte]] = [
        [0x00, 0x00, 0x00, 0x00],
        [0x01, 0x00, 0x00, 0x00],
        [0x02, 0x00, 0x00, 0x00],
        [0x04, 0x00, 0x00, 0x00],
        [0x08, 0x00, 0x00, 0x00],
        [0x10, 0x00, 0x00, 0x00],
        [0x20, 0x00, 0x00, 0x00],
        [0x40, 0x00, 0x00, 0x00],
        [0x80, 0x00, 0x00, 0x00],
        [0x1B, 0x00, 0x00, 0x00],
        [0x36, 0x00, 0x00, 0x00]
    ]
    
    static let affineConstBinary: [Int] = [0, 1, 1, 0, 0, 0, 1, 1]
}
