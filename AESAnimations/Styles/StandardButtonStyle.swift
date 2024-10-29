//
//  StandardButtonStyle.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.10.24.
//

import SwiftUI

struct StandardButtonStyle: ButtonStyle {
    @State private var isHovered: Bool = false
    
    var font: Font = .headline
    var padding: CGFloat = 5
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(padding)
            .background(fillColor)
            .highlightEffect(isHovered: $isHovered)
            .font(font)
            .foregroundStyle(Color.accentColor)
            .pressEffect(isPressed: configuration.isPressed)
           
    }
    
    var fillColor: some View {
        isHovered
        ? (padding > 0 ? RoundedRectangle(cornerRadius: 5).fill(Color.ultraLightGray) : nil)
        : nil
    }
}

extension ButtonStyle where Self == StandardButtonStyle {
    static var standard: StandardButtonStyle {
        StandardButtonStyle()
    }
}
