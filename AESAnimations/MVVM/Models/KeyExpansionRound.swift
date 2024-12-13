//
//  RoundOfRKey.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 04.09.24.
//

import SwiftUI

/// A data structure for storing information about a single round
/// in the AES Key Expansion process.
struct KeyExpansionRound: Identifiable, Equatable {
    let id: UUID = UUID()
    let index: Int
    let temp: [Byte]
    var afterRotWord: [Byte] = []
    var afterSubWord: [Byte] = []
    var rcon: [Byte] = []
    var afterXORWithRCON: [Byte] = []
    var wIMinusNK: [Byte] = []
    var result: [Byte] = []
    
    static func == (lhs: KeyExpansionRound, rhs: KeyExpansionRound) -> Bool {
            return lhs.index == rhs.index &&
                lhs.temp == rhs.temp &&
                lhs.afterRotWord == rhs.afterRotWord &&
                lhs.afterSubWord == rhs.afterSubWord &&
                lhs.rcon == rhs.rcon &&
                lhs.afterXORWithRCON == rhs.afterXORWithRCON &&
                lhs.wIMinusNK == rhs.wIMinusNK &&
                lhs.result == rhs.result
        }
}
