//
//  RoundKeysAttachment.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 04.09.24.
//

import SwiftUI

struct RoundKeyHistory: View {
    let navigationTitle: LocalizedStringKey
    let keyExpRounds: [KeyExpansionRound]

    let header: [(String, CGFloat)] = [
        ("i", 25),
        ("Temp", 130),
        ("After RotWord", 130),
        ("After SubWord", 130),
        ("rCon[i / nK]", 130),
        ("After ⊕ with rCon", 130),
        ("w[i - nK]", 130),
        ("w[i] = temp ⊕ w[i - nK]", 130)
    ]
    
    var keyExpansionData: [[Any]] {
        keyExpRounds.map { round in
            [
                round.index,
                round.temp,
                round.afterRotWord,
                round.afterSubWord,
                round.rcon,
                round.afterXORWithRCON,
                round.wIMinusNK,
                round.result
            ]
        }
    }
    
    var body: some View {
        GenericDataView(
            navigationTitle: navigationTitle,
            data: keyExpansionData,
            header: header
        )
     
    }
}
