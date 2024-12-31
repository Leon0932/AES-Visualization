//
//  StateView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.08.24.
//

import SwiftUI

/// A view representing the state, including properties for animations.
struct StateView: View {
    // MARK: - Properties
    var title: LocalizedStringKey?
    var state: [[Byte]]
    var position: PositionType = .oneD(Array(repeating: Position(x: 0.0, y: 0.0), count: 8))
    var opacity: OpacityType = .oneD(Array(repeating: 1.0, count: 8))
    var backgroundColor: Color? = nil
    var foregroundStyle: Color = .primary
    
    var boxSize: CGFloat = LayoutStyles.cellSize
    var alignment: HorizontalAlignment = .center
    var spacing: CGFloat = LayoutStyles.spacingMatrix
    
    // MARK: -
    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            if let title = title {
                StateTitle(title: title)
                    .opacity(opacity(forRow: 0, col: 0))
            }
            
            ForEach(0..<state.count,
                    id: \.self,
                    content: matrixRowView(row:))
        }
    }
    
    // MARK: - Matrix View
    /// A view that represents a row of a matrix with animations.
    ///
    /// - Parameter row: The current row to be displayed.
    /// - Returns: A view representing the matrix row.
    func matrixRowView(row: Int) -> some View {
        HStack(spacing: spacing) {
            ForEach(0..<state[row].count, id: \.self) { col in
                let value = state[row][col]
                
                CellView(
                    value: value,
                    boxSize: boxSize,
                    backgroundColor: backgroundColor ?? .reducedByteColor(value),
                    foregroundStyle: foregroundStyle
                )
                .offset(x: offset(forRow: row, col: col, isX: true),
                        y: offset(forRow: row, col: col, isX: false)
                )
                .opacity(opacity(forRow: row, col: col))
            }
        }
    }
    
    // MARK: - Helper Functions
    
    /// Helper function to determine whether the parameters represent a one-dimensional or two-dimensional array
    /// of `positions`.
    ///
    /// - Parameters:
    ///   - row: The current row index.
    ///   - col: The current column index.
    ///   - isX: A flag indicating whether the offset is along the X-axis.
    /// - Returns: The calculated position as a `CGFloat`.
    private func offset(forRow row: Int, col: Int, isX: Bool) -> CGFloat {
        switch position {
        case .oneD(let positions):
            return isX ? positions[col].x : positions[col].y
        case .twoD(let positions):
            return isX ? positions[row][col].x : positions[row][col].y
        }
    }
    
    /// Helper function to determine whether the parameters represent a one-dimensional or two-dimensional array
    /// of `opacities`.
    ///
    /// - Parameters:
    ///   - row: The current row index.
    ///   - col: The current column index.
    /// - Returns: The calculated opacity as a `Double`.
    private func opacity(forRow row: Int, col: Int) -> Double {
        switch opacity {
        case .oneD(let opacities):
            return opacities[col]
        case .twoD(let opacities):
            return opacities[row][col]
        }
    }
}

/// A helper view for displaying a title.
struct StateTitle: View {
    let title: LocalizedStringKey
    
    var body: some View {
        Text(title)
            .font(TextStyles.headline)
            .frame(maxHeight: LayoutStyles.titleHeight)
    }
}
