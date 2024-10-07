//
//  CellView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import SwiftUI

enum ValueFormat {
    case oneDigit
    case twoDigit
    case number
}

struct CellView: View {
    // MARK: - Properties
    let value: Byte
    let boxSize: CGFloat
    let backgroundColor: Color
    var foregroundColor: Color = .primary
    
    var valueFormat: ValueFormat = .twoDigit

    // MARK: -
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
            .background(RoundedRectangle(cornerRadius: 3).fill(backgroundColor))
            .foregroundColor(foregroundColor)
    }
}


