//
//  HighlightEffectModifier.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.10.24.
//

import SwiftUI

/// Source: https://developer.apple.com/documentation/swiftui/viewmodifier
/// ViewModifier for `buttonStyle`
struct HighlightEffectModifier: ViewModifier {
    // MARK: - Properties
    @Binding var isHovered: Bool
    
    /// Applies a view modifier that creates a hover effect on the content (Button), producing a pressed look and animating the scale change.
    /// On iOS, it uses `hoverEffect(.highlight)` with a rounded rectangle shape; on macOS, it tracks hover state with `onHover`
    /// and applies an ease-in-out animation.
    ///
    /// - Parameter content: The content to which the modifier is applied.
    /// - Returns: The modified view with a platform-specific hover or highlight effect.
    func body(content: Content) -> some View {
        content
            #if os(iOS)
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .hoverEffect(.highlight)
            #else
            .onHover { isHovered = $0 }
            .animation(.easeInOut, value: isHovered)
            #endif
        
    }
}
