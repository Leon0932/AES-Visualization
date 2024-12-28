//
//  CipherHistory.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 30.09.24.
//

import SwiftUI

struct CipherHistory: View {
    let navigationTitle: String
    let cipherRounds: [CipherRound]
    let isDecryption: Bool
    
    var header: [(LocalizedStringKey, CGFloat)] {
        isDecryption ?
        [
            ("#", 25),
            ("Start der Runde / Nach InvSubBytes", 170),
            ("Rundenschlüsselwert", 200),
            ("Nach AddRoundKey", 170),
            ("Nach InvMixColumns", 170),
            ("Nach InvShiftRows", 170),
        ]:
        [
            ("#", 25),
            ("Start der Runde / Nach AddRoundKey", 170),
            ("Nach SubBytes", 170),
            ("Nach ShiftRows", 170),
            ("Nach MixColumns", 170),
            ("Rundenschlüsselwert", 200),
        ]
    }
    var cipherRowData: [[Any]] {
        cipherRounds.map { round in
            isDecryption ?
            [
                round.index,
                round.startOfRound,
                round.roundKey,
                round.afterAddRound,
                round.afterMixColumns,
                round.afterShiftRows,
                
            ] :
            [
                round.index,
                round.startOfRound,
                round.afterSubBytes,
                round.afterShiftRows,
                round.afterMixColumns,
                round.roundKey
            ]
        }
    }
    
    var body: some View {
        GenericDataView(
            navigationTitle: navigationTitle,
            data: cipherRowData,
            header: header
        )
    }
}
