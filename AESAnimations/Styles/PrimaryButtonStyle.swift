//
//  PrimaryButtonStyle.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 24.10.24.
//

import SwiftUI

/// Source: https://developer.apple.com/documentation/swiftui/buttonstyle
/// Button style for primary buttons with the primary color as background
/// and white color for the foreground.
struct PrimaryButtonStyle: ButtonStyle {
    // MARK: - Properties
    @State private var isHovered: Bool = false
    
    var useMaxWidth: Bool = false
    var isDisabled: Bool = false
    
    /// Creates a view that represents the body of a button.
    ///
    /// Creates a style with the primary color for the background, a white color
    /// for the foreground and including `highlightEffect` and `pressEffect`
    ///
    /// - Parameter configuration: The properties of a button.
    /// - Returns: A view that represents the body of a button.
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
    
    /// Checks if the button is disabled, and then if on an iPad with a keyboard or on a Mac, checks if it is hovered.
    ///
    /// - Parameter configuration: The properties of a button.
    /// - Returns: Color of the button
    func fillColor(_ configuration: Configuration) -> Color {
        isDisabled
        ? Color.gray
        : (configuration.isPressed || isHovered ? Color.accentColor.opacity(0.4) : Color.accentColor)
    }
    
}

/// Helper extension for views to use only `.primary` in the `buttonStyle` view modifier.
extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}
