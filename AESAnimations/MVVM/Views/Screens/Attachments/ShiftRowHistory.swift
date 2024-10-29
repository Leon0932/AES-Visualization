//
//  ShiftRowHistory.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 29.09.24.
//

import SwiftUI

struct ShiftRowHistory: View {
    let navigationTitle: String
    let shiftRowRounds: [ShiftRowRound]
    
    let header: [(String, CGFloat)] = [
        ("Index", 100),
        ("Temp", 150),
        ("After first Shift", 150),
        ("After second Shift", 150),
        ("Last Shift", 150),
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
