//
//  StateView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.08.24.
//

import SwiftUI

struct StateView: View {
    // MARK: - Properties
    var title: String?
    var state: [[Byte]]
    var position: PositionType = .oneD(Array(repeating: Position(x: 0.0, y: 0.0), count: 8))
    var opacity: OpacityType = .oneD(Array(repeating: 1.0, count: 8))
    var backgroundColor: Color
    var foregroundColor: Color = .primary
    
    var boxSize: CGFloat = 50
    var alignment: HorizontalAlignment = .center
    var spacing: CGFloat = 10
    
    // MARK: -
    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            if let title = title { titleView(for: title) }
            
            ForEach(0..<state.count,
                    id: \.self,
                    content: matrixView(row:))
        }
    }
    
    // MARK: - Title View
    func titleView(for title: String) -> some View {
        Text(title)
            .font(.system(size: 17))
            .fontWeight(.semibold)
            .frame(maxHeight: 15)
            .opacity(opacity(forRow: 0, col: 0))
    }
    
    // MARK: - Matrix View
    func matrixView(row: Int) -> some View {
        HStack(spacing: spacing) {
            ForEach(0..<state[row].count, id: \.self) { col in
                CellView(
                    value: state[row][col],
                    boxSize: boxSize,
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor
                )
                .offset(x: offsetX(forRow: row, col: col),
                        y: offsetY(forRow: row, col: col))
                .opacity(opacity(forRow: row, col: col))
            }
        }
    }
    
    // MARK: - Helper Functions
    private func offsetX(forRow row: Int, col: Int) -> CGFloat {
        switch position {
        case .oneD(let positions):
            return positions[col].x
        case .twoD(let positions):
            return positions[row][col].x
        }
    }
    
    private func offsetY(forRow row: Int, col: Int) -> CGFloat {
        switch position {
        case .oneD(let positions):
            return positions[col].y
        case .twoD(let positions):
            return positions[row][col].y
        }
    }
    
    private func opacity(forRow row: Int, col: Int) -> Double {
        switch opacity {
        case .oneD(let opacities):
            return opacities[col]
        case .twoD(let opacities):
            return opacities[row][col]
        }
    }
}

