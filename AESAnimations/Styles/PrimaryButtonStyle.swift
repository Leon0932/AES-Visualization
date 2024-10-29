//
//  PrimaryButtonStyle.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 24.10.24.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @State private var isHovered: Bool = false
    
    var useMaxWidth: Bool = false
    var isDisabled: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(Color.white)
            .frame(maxWidth: useMaxWidth ? .infinity : nil)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(fillColor(configuration))
            )
            .disabled(isDisabled)
            .highlightEffect(isHovered: $isHovered)
            .pressEffect(isPressed: configuration.isPressed)
      
    }
    
    func fillColor(_ configuration: Configuration) -> Color {
        isDisabled
        ? Color.gray
        : (configuration.isPressed || isHovered ? Color.accentColor.opacity(0.4) : Color.accentColor)
    }
    
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}
