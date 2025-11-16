//
//  SecondaryButtonStyle.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 24.10.24.
//

import SwiftUI

/// Source: https://developer.apple.com/documentation/swiftui/buttonstyle
/// Button style for secondary buttons with a light primary background
/// and primary color for the foreground.
struct SecondaryButtonStyle: ButtonStyle {
    // MARK: - Properties
    @State private var isHovered: Bool = false
    
    var padding: CGFloat = 12
    var font: Font = .body

    /// Creates a view that represents the body of a button.
    ///
    /// Creates a style with a light primary color for the background, the primary color
    ///  for the foreground including `pressEffect`
    ///
    /// - Parameter configuration: The properties of a button.
    /// - Returns: A view that represents the body of a button.
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(padding)
            .font(font)
            .buttonBackground(fillColor(configuration))
            .foregroundStyle(Color.accentColor)
            .pressEffect(isPressed: configuration.isPressed)
    }
    
    
    /// Checks if the button is pressed, or if on an iPad with a keyboard or on a Mac, checks if it is hovered.
    /// - Parameter configuration: The properties of a button.
    /// - Returns: Color of the button
    func fillColor(_ configuration: Configuration) -> Color {
        configuration.isPressed || isHovered
        ? Color.accentColor.opacity(0.4)
        : Color.accentColor.opacity(0.2)
    }
    
}

/// Helper extension for views to use only `.secondary` in the `buttonStyle` view modifier.
extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: SecondaryButtonStyle {
        SecondaryButtonStyle()
    }
}
