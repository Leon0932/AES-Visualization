//
//  PositionTrackingModifier.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 31.12.24.
//

import SwiftUI

/// Source: https://developer.apple.com/documentation/swiftui/viewmodifier
/// A ViewModifier to track the position of a component in the global coordinate system.
struct PositionTrackingModifier: ViewModifier {
    // MARK: - Properties
    let onPosition: (Position) -> Void
    
    /// Applies the position-tracking logic to the view.
    ///
    /// - Parameter content: The view to which the modifier is applied.
    /// - Returns: A modified view with position-tracking capabilities.
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            let position = geometry.frame(in: .global).origin
                            onPosition(Position(x: position.x, y: position.y))
                        }
                }
            )
    }
}
