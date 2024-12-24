//
//  ShiftRowsHistory.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 29.09.24.
//

import SwiftUI

struct ShiftRowsHistory: View {
    let navigationTitle: String
    let shiftRowRounds: [ShiftRowRound]
    
    let header: [(LocalizedStringKey, CGFloat)] = [
        ("#", 100),
        ("Start", 150),
        ("Nach erster Verschiebung", 150),
        ("Nach zweiter Verschiebung", 150),
        ("Letzte Verschiebung", 150),
    ]
    
    var shiftRowData: [[Any]] {
        shiftRowRounds.map { round in
            [
                round.index,
                round.temp,
                round.shifts[0],
                round.shifts[1],
                round.shifts[2],
            ]
        }
    }
    
    var body: some View {
        GenericDataView(
            navigationTitle: navigationTitle,
            data: shiftRowData,
            header: header
        )
     
    }
}
