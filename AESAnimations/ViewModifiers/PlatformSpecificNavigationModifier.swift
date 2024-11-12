//
//  PlatformSpecificNavigationModifier.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 29.09.24.
//

import SwiftUI

/// Source: https://developer.apple.com/documentation/swiftui/viewmodifier
/// A ViewModifier for navigation on iPad and Mac.
/// Note: `.fullScreenCover` is available only on iOS and iPadOS.
struct PlatformSpecificNavigationModifier<Destination: View>: ViewModifier {
    // MARK: - Properties
    @Binding var isPresented: Bool
    let destination: () -> Destination
    
    /// Applies a view modifier based on the platform, using `fullScreenCover` for iPadOS and
    /// `navigationDestination` for macOS to present the specified destination view.
    ///
    /// - Parameter content: The content to which the modifier is applied.
    /// - Returns: The modified view with the appropriate presentation style.
    func body(content: Content) -> some View {
        #if os(iOS)
        content.fullScreenCover(isPresented: $isPresented) {
            destination()
        }
        #else
        content.navigationDestination(isPresented: $isPresented) {
            destination()
        }
        #endif
    }
}

