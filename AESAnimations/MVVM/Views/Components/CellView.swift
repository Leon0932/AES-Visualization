//
//  CellView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import SwiftUI

/// A view that displays a byte (or number) in a box format.
struct CellView: View {
    // MARK: - Properties
    let value: Byte
    let boxSize: CGFloat
    var backgroundColor: Color
    var foregroundStyle: Color = .primary
    
    var valueFormat: ValueFormat = .twoDigit
    
    // MARK: - Body
    var body: some View {
        Text(
            String(format: {
                switch valueFormat {
                case .oneDigit:
                    return "%01X"
                case .twoDigit:
                    return "%02X"
                case .number:
                    return "%d"
                }
            }(), value)
        )
        .fontDesign(.monospaced)
        .frame(width: boxSize, height: boxSize)
        .background(
            RoundedRectangle(cornerRadius: 3)
                .fill(backgroundColor)
        )
        .foregroundStyle(foregroundStyle)
    }
}


