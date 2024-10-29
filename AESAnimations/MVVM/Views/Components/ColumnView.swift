//
//  ColumnView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 03.09.24.
//

import SwiftUI

struct ColumnView: View {
    // MARK: - Properties
    var column: [Byte]
    var position: [Position] = Position.default1DPositions(count: 4)
    var opacity: Double = 1.0
    var backgroundColor: Color?
    var foregroundStyle: Color = .primary
    var highlightColumn: Bool? = nil
    
    var boxSize: CGFloat = 50
    var spacing: CGFloat = 10
    
    // MARK: -
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<4) { index in
                CellView(value: column[index],
                         boxSize: boxSize,
                         backgroundColor: highlightColor(value: column[index],
                                                         index: index),
                         foregroundStyle: foregroundStyle)
                .offset(x: position[index].x,
                        y: position[index].y)
                
            }
        }
        .opacity(opacity)
    }
    
    private func highlightColor(value: Byte, index: Int) -> Color {
        if let highlightColumn = highlightColumn {
            return highlightColumn ? .activeByteColor(value, to: 0.8) : .reducedByteColor(value)
        }
        
        return backgroundColor ?? .reducedByteColor(value)
    }
}
