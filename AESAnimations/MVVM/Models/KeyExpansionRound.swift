//
//  RoundOfRKey.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 04.09.24.
//

import SwiftUI

/// A data structure for storing information about a single round
/// in the AES Key Expansion process.
struct KeyExpansionRound: Identifiable {
    let id: UUID = UUID()
    let index: Int
    let temp: [Byte]
    var afterRotWord: [Byte] = []
    var afterSubWord: [Byte] = []
    var rcon: [Byte] = []
    var afterXORWithRCON: [Byte] = []
    var wIMinusNK: [Byte] = []
    var result: [Byte] = []
}
