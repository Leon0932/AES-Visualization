//
//  SBoxView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import SwiftUI

struct SBoxView: View {
    // MARK: - Properties 
    @Binding var searchResult: Byte?
    let isInverseMode: Bool
    
    var searchX: Byte? = nil
    var searchY: Byte? = nil

    private var gridItems: [GridItem] {
        Array(repeating: .init(.fixed(boxSize()), spacing: 4), count: 16)
    }
    
    let aesMath = AESMath()

    // MARK: -
    var body: some View {
        VStack(spacing: 2) {
            headerRow
            ForEach(0..<16, id: \.self) { row in
                rowView(for: row)
            }
        }
    }

    // MARK: - Header-Row (Y-Achses) View
    private var headerRow: some View {
        HStack(spacing: 4) {
            CellView(value: 0x00, boxSize: boxSize(), backgroundColor: .clear, foregroundColor: .clear)
            
            ForEach(0..<16, id: \.self) { col in
                CellView(
                    value: Byte(col),
                    boxSize: boxSize(),
                    backgroundColor: headerBackgroundColor(for: col),
                    valueFormat: .oneDigit
                )
            }
        }
    }

    // MARK: - Row (with X-Achses) View
    private func rowView(for row: Int) -> some View {
        HStack(spacing: 4) {
            CellView(
                value: Byte(row),
                boxSize: boxSize(),
                backgroundColor: rowBackgroundColor(for: row),
                valueFormat: .oneDigit
            )
            
            LazyVGrid(columns: gridItems, spacing: 4) {
                ForEach(0..<16, id: \.self) { col in
                    cellView(row: row, col: col)
                        .scaleEffect(searchResult != nil && Int(searchResult ?? 0) == (row * 16 + col) 
                                     ? 2
                                     : 1)
                }
            }
        }
    }

    // MARK: - S-Box Values
    private func cellView(row: Int, col: Int) -> some View {
        let index = row * 16 + col
        let value = isInverseMode ? aesMath.invSBox(Byte(index)) : aesMath.sBox(Byte(index))
        
        return CellView(
            value: value,
            boxSize: boxSize(),
            backgroundColor: cellBackgroundColor(for: index, row: row, col: col),
            foregroundColor: cellForegroundColor(for: index)
        )
    }

    // MARK: - Helper Functions
    private func headerBackgroundColor(for col: Int) -> Color {
        guard let searchY else { return .ultraLightGray }
        
        return Byte(col) == searchY ? .reducedAccentColor : .ultraLightGray
    }
    
    private func rowBackgroundColor(for row: Int) -> Color {
        guard let searchX else { return .ultraLightGray }
        
        return Byte(row) == searchX ? .reducedAccentColor : .ultraLightGray
    }

    private func cellBackgroundColor(for index: Int, row: Int, col: Int) -> Color {
        if let searchResult = searchResult, Int(searchResult) == index {
            return .accentColor
        }
        
        if let searchX = searchX, searchX == row {
            return .reducedAccentColor
        }
        
        if  let searchY = searchY, searchY == col {
            return .reducedAccentColor
        }
        
        return .lightGray
    }

    private func cellForegroundColor(for index: Int) -> Color {
        guard let searchResult = searchResult else { return .primary }
        return Int(searchResult) == index ? .white : .primary
    }
}


