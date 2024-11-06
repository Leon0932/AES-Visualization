//
//  StateView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.08.24.
//

import SwiftUI

struct StateView: View {
    // MARK: - Properties
    var title: LocalizedStringKey?
    var state: [[Byte]]
    var position: PositionType = .oneD(Array(repeating: Position(x: 0.0, y: 0.0), count: 8))
    var opacity: OpacityType = .oneD(Array(repeating: 1.0, count: 8))
    var backgroundColor: Color? = nil
    var foregroundStyle: Color = .primary
    
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
    func titleView(for title: LocalizedStringKey) -> some View {
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
    private func offset(forRow row: Int, col: Int, isX: Bool) -> CGFloat {
        switch position {
        case .oneD(let positions):
            return isX ? positions[col].x : positions[col].y
        case .twoD(let positions):
            return isX ? positions[row][col].x : positions[row][col].y
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

