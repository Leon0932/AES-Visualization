//
//  SecondaryButtonStyle.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 24.10.24.
//

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    @State private var isHovered: Bool = false
    
    var padding: CGFloat = 8
    var font: Font = .body
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(padding)
            .font(font)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(fillColor(configuration))
            )
            .foregroundStyle(Color.accentColor)
            .highlightEffect(isHovered: $isHovered)
            .pressEffect(isPressed: configuration.isPressed)
    }
    
    func fillColor(_ configuration: Configuration) -> Color {
        configuration.isPressed || isHovered ? Color.accentColor.opacity(0.4) : Color.accentColor.opacity(0.2)
    }
    
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: SecondaryButtonStyle {
        SecondaryButtonStyle()
    }
}
