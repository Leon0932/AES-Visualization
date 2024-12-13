//
//  CipherRound.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 30.09.24.
//

import SwiftUI

/// A data structure for storing information about a single cipher round
/// in the AES encryption or decryption process.
struct CipherRound: Identifiable, Equatable {
    let id: UUID = UUID()
    let index: Int
    let startOfRound: [[Byte]]
    var afterAddRound: [[Byte]] = [[]]
    var afterSubBytes: [[Byte]] = [[]]
    var afterShiftRows: [[Byte]] = [[]]
    var afterMixColumns: [[Byte]] = [[]]
    var roundKey: [[Byte]] = [[]]
    
    static func == (lhs: CipherRound, rhs: CipherRound) -> Bool {
        return lhs.index == rhs.index &&
        lhs.startOfRound == rhs.startOfRound &&
        lhs.afterAddRound == rhs.afterAddRound &&
        lhs.afterSubBytes == rhs.afterSubBytes &&
        lhs.afterShiftRows == rhs.afterShiftRows &&
        lhs.afterMixColumns == rhs.afterMixColumns &&
        lhs.roundKey == rhs.roundKey
    }
}


