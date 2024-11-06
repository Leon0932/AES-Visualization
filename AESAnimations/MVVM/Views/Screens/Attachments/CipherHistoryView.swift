//
//  CipherHistory.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 30.09.24.
//

import SwiftUI

struct CipherHistoryView: View {
    let navigationTitle: String
    let cipherRounds: [CipherRound]
    let isDecryption: Bool
    
    var header: [(String, CGFloat)] {
        isDecryption ?
        [
            ("Round Number", 100),
            ("Start of Round / After InvSubBytes", 170),
            ("Round Key Value", 170),
            ("After AddRoundKey", 170),
            ("After InvMixColumns", 170),
            ("After InvShiftRows", 170),
            
        ] :
        [
            ("Round Number", 100),
            ("Start of Round / After AddRoundKey", 170),
            ("After SubBytes", 170),
            ("After ShiftRows", 170),
            ("After MixColumns", 170),
            ("Round Key Value", 170),
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
