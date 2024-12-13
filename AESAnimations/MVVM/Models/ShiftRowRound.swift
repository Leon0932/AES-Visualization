//
//  ShiftRowRound.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 29.09.24.
//

import SwiftUI

/// A data structure for storing information about a single round
/// in the ShiftRows step of the AES encryption or decryption process.
struct ShiftRowRound: Identifiable, Equatable {
    let id: UUID = UUID()
    let index: Int
    let temp: [Byte]
    var shifts: [[Byte]]
    
    static func == (lhs: ShiftRowRound, rhs: ShiftRowRound) -> Bool {
        return lhs.index == rhs.index &&
        lhs.temp == rhs.temp &&
        lhs.shifts == rhs.shifts
    }
}
