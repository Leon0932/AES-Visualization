//
//  SBoxView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import SwiftUI

struct SBoxView: View {
    // MARK: - Properties
    let isInverseMode: Bool
    var sBoxIndex: Byte? = nil
    var searchResult: Byte? = nil
    var searchX: Byte? = nil
    var searchY: Byte? = nil
    var opacityOfValues: [[Double]] = Array.create2DArray(repeating: 1.0, rows: 16, cols: 16)
    
    // Helper Properties
    private var gridItems: [GridItem] {
        Array(repeating: .init(.fixed(boxSizeForiPad()), spacing: 4), count: 16)
    }
    
    private var byteColor: Byte {
        guard let sBoxIndex else { return 0 }
        let value = getValue(index: Int(sBoxIndex))
        
        return value
    }
    
    private let aesMath = AESMath.shared
    
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
            CellView(value: 0x00,
                     boxSize: boxSizeForiPad(),
                     backgroundColor: .clear,
                     foregroundStyle: .clear)
            
            ForEach(0..<16, id: \.self) { col in
                CellView(
                    value: Byte(col),
                    boxSize: boxSizeForiPad(),
                    backgroundColor: Byte(col) == searchY ? .reducedByteColor(byteColor) : .ultraLightGray,
                    valueFormat: .oneDigit
                )
                .opacity(checkOpacity() ? 1.0 : 0.0)
            }
        }
    }
    
    // MARK: - Row (with X-Achses) View
    private func rowView(for row: Int) -> some View {
        HStack(spacing: 4) {
            CellView(
                value: Byte(row),
                boxSize: boxSizeForiPad(),
                backgroundColor: Byte(row) == searchX ? .reducedByteColor(byteColor) : .ultraLightGray,
                valueFormat: .oneDigit
            )
            .opacity(checkOpacity() ? 1.0 : 0.0)
            
            LazyVGrid(columns: gridItems, spacing: 4) {
                ForEach(0..<16, id: \.self) { col in
                    cellView(row: row, col: col)
                        .scaleEffect(searchResult != nil && Int(searchResult!) == getIndex(row: row, col: col)
                                     ? 2
                                     : 1)
                        .opacity(opacityOfValues[row][col])
                }
            }
        }
    }
    
    // MARK: - S-Box Value
    private func cellView(row: Int, col: Int) -> some View {
        CellView(
            value: getValue(index: getIndex(row: row, col: col)),
            boxSize: boxSizeForiPad(),
            backgroundColor: cellBackgroundColor(for: getIndex(row: row, col: col),
                                                 row: row,
                                                 col: col)
        )
    }
    
    // MARK: - Helper Functions
    private func getIndex(row: Int, col: Int) -> Int { row * 16 + col }
    
    private func getValue(index: Int) -> Byte {
        isInverseMode ? aesMath.invSBox(Byte(index)) : aesMath.sBox(Byte(index))
    }
    
    private func cellBackgroundColor(for index: Int, row: Int, col: Int) -> Color {
        if let searchResult = searchResult, Int(searchResult) == index {
            return .activeByteColor(byteColor, to: 0.8)
        }
        
        if let searchX = searchX, searchX == row {
            return .reducedByteColor(byteColor)
        }
        
        if let searchY = searchY, searchY == col {
            return .reducedByteColor(byteColor)
        }
        
        return .lightGray
    }
    
    private func checkOpacity() -> Bool {
        opacityOfValues.contains { $0.contains { $0 == 1.0 } }
    }
}


