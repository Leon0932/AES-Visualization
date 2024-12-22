//
//  ShiftRowRound.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 29.09.24.
//

import SwiftUI

/// A data structure for storing information about a single round
/// in the ShiftRows step of the AES encryption or decryption process.
struct ShiftRowRound: Identifiable {
    let id: UUID = UUID()
    let index: Int
    let temp: [Byte]
    var shifts: [[Byte]]
}
