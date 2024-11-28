//
//  StandardButtonStyle.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.10.24.
//

import SwiftUI

/// Source: https://developer.apple.com/documentation/swiftui/buttonstyle
/// Button style for standard buttons with the primary color for the foreground color
struct StandardButtonStyle: ButtonStyle {
    // MARK: - Properties
    @State private var isHovered: Bool = false
    
    var font: Font = .headline
    var padding: CGFloat = 5
    var isDisabled: Bool = false
    
    /// Creates a view that represents the body of a button.
    ///
    /// Creates a style with the primary color for the foreground,
    /// including `highlightEffect` and `pressEffect`
    ///
    /// - Parameter configuration: The properties of a button.
    /// - Returns: A view that represents the body of a button.
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(padding)
            .background(fillColor)
            .highlightEffect(isHovered: $isHovered)
            .font(font)
            .foregroundStyle(isDisabled ? Color.lightGray : Color.accentColor)
            .disabled(isDisabled)
            .pressEffect(isPressed: configuration.isPressed)
           
    }
    
    /// Checks if the button is pressed, or if on an iPad with a keyboard or on a Mac, checks if it is hovered.
    var fillColor: some View {
        isHovered
        ? (padding > 0 ? RoundedRectangle(cornerRadius: 5).fill(Color.ultraLightGray) : nil)
        : nil
    }
}

/// Helper extension for views to use only `.standard` in the `buttonStyle` view modifier.
extension ButtonStyle where Self == StandardButtonStyle {
    static var standard: StandardButtonStyle {
        StandardButtonStyle()
    }
}
