//
//  SBoxView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import SwiftUI

/// A view for displaying the S-Box and
/// searching for bytes, including animations
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
        Array(repeating: .init(.fixed(calculateCellSize()), spacing: 4), count: 16)
    }
    
    private var byteColor: Byte {
        guard let sBoxIndex else { return 0 }
        let value = getSBoxValue(index: Int(sBoxIndex))
        
        return value
    }
    
    private let aesMath = AESMath.shared
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 2) {
            headerRow
            ForEach(0..<16,
                    id: \.self,
                    content: rowView(for:))
        }
    }
    
    // MARK: - Header-Row (Y-Axis) View
    private var headerRow: some View {
        HStack(spacing: 4) {
            // Invisible Box for
            // formatting the View
            CellView(value: 0x00,
                     boxSize: calculateCellSize(),
                     backgroundColor: .clear,
                     foregroundStyle: .clear)
            
            ForEach(0..<16, id: \.self) { col in
                // Col Number
                axisValueView(isRow: false, value: col)
            }
        }
    }
    
    // MARK: - Row (with X-Axis) View
    private func rowView(for row: Int) -> some View {
        HStack(spacing: 4) {
            // Row Number
            axisValueView(isRow: true, value: row)
            
            LazyVGrid(columns: gridItems, spacing: 4) {
                ForEach(0..<16, id: \.self) { col in
                    sBoxValueView(row: row, col: col)
                        .scaleEffect(searchResult != nil && Int(searchResult!) == getIndex(row: row, col: col)
                                     ? 2
                                     : 1)
                        .opacity(opacityOfValues[row][col])
                }
            }
        }
    }
    
    // MARK: - S-Box Value
    private func sBoxValueView(row: Int, col: Int) -> some View {
        CellView(
            value: getSBoxValue(index: getIndex(row: row, col: col)),
            boxSize: calculateCellSize(),
            backgroundColor: cellBackgroundColor(for: getIndex(row: row, col: col),
                                                 row: row,
                                                 col: col)
        )
    }
    
    private func axisValueView(isRow: Bool, value: Int) -> some View {
        let axisValue = isRow ? searchX : searchY
        let byteValue = Byte(value)
        
        return CellView(
            value: byteValue,
            boxSize: calculateCellSize(),
            backgroundColor: byteValue == axisValue ? .reducedAccentColor : .ultraLightGray,
            valueFormat: .oneDigit
        )
        .opacity(containsOneOpacity() ? 1.0 : 0.0)
    }
    
    // MARK: - Helper Functions

    /// Calculates the index based on the given `row` and `col`.
    ///
    /// - Parameters:
    ///   - row: The row number.
    ///   - col: The column number.
    /// - Returns: An index in the range 0–255.
    private func getIndex(row: Int, col: Int) -> Int {
        row * 16 + col
    }
    
    /// Retrieves the S-Box value from the lookup table (`sBox` or `invSBox`) at the specified index.
    ///
    /// - Parameter index: The current index.
    /// - Returns: The S-Box value as a byte.
    private func getSBoxValue(index: Int) -> Byte {
        isInverseMode ? aesMath.invSBox(Byte(index)) : aesMath.sBox(Byte(index))
    }
    
    /// Calculates the background color when searching for a byte.
    ///
    /// This function searches for a byte and, if the byte is found, displays the byte's corresponding color.
    /// Otherwise, it checks whether the current row or column has a value, in which case a reduced primary color is used.
    /// If no animation is active, a light gray color is displayed.
    ///
    /// - Parameters:
    ///   - index: The current index.
    ///   - row: The row number.
    ///   - col: The column number.
    /// - Returns: The resulting color.
    private func cellBackgroundColor(for index: Int, row: Int, col: Int) -> Color {
        if let searchResult = searchResult, Int(searchResult) == index {
            return .activeByteColor(byteColor, to: 0.8)
        }
        
        if let searchX = searchX, searchX == row {
            return .reducedAccentColor
        }
        
        if let searchY = searchY, searchY == col {
            return .reducedAccentColor
        }
        
        return .lightGray
    }
    
    /// Checks whether the 2D array contains a value of 1.0.
    ///
    /// - Parameter array: A 2D array of `Double` values.
    /// - Returns: `true` if the array contains a value of 1.0, otherwise `false`.
    private func containsOneOpacity() -> Bool {
        opacityOfValues.contains { $0.contains { $0 == 1.0 } }
    }
    
    /// Calculates the box size based on the specific device type.
    ///
    /// For example, an iPad with a 13-inch screen uses a box size of 40 points.
    ///
    /// - Returns: The calculated box size in points.
    private func calculateCellSize() -> CGFloat {
        #if os(iOS)
        return DeviceDetector.isPad13Size() ? 40 : 35
        #else
        return 37
        #endif
    }
    
}


