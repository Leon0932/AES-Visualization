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
    var backgroundColor: Color = .accentColor
    var foregroundColor: Color = .white
    
    var boxSize: CGFloat = 50
    var spacing: CGFloat = 10
    
    // MARK: -
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<4) { index in
                CellView(value: column[index],
                         boxSize: boxSize,
                         backgroundColor: backgroundColor,
                         foregroundColor: foregroundColor)
                .offset(x: position[index].x,
                        y: position[index].y)
                
            }
        }
        .opacity(opacity)
    }
}
