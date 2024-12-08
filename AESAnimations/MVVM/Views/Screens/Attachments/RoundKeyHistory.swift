//
//  RoundKeysAttachment.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 04.09.24.
//

import SwiftUI

struct RoundKeyHistory: View {
    let navigationTitle: String
    let keyExpRounds: [KeyExpansionRound]

    let header: [(LocalizedStringKey, CGFloat)] = [
        ("#", 25),
        ("Start", 130),
        ("Nach RotWord", 130),
        ("Nach SubWord", 130),
        ("rCon[i / nK]", 130),
        ("Nach ⊕ mit rCon", 130),
        ("w[i - nK]", 130),
        ("w[i] = Start ⊕ w[i - nK]", 130)
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
