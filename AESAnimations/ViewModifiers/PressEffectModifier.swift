//
//  PressEffectModifier.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.10.24.
//

import SwiftUI

/// Source: https://developer.apple.com/documentation/swiftui/viewmodifier
/// ViewModifier for `buttonStyle`
struct PressEffectModifier: ViewModifier {
    // MARK: - Properties
    var isPressed: Bool
    
    /// Applies a view modifier that scales the content (Buttons, ...) to create a pressed effect and animates the scale change.
    ///
    /// - Parameter content: The content to which the modifier is applied.
    /// - Returns: The modified view with a scaling effect when pressed, using an animation with an ease-in-out transition.
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
    }
}
