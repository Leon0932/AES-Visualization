//
//  NavigationBackButtonModifier.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 06.10.24.
//

import SwiftUI

/// Source: https://developer.apple.com/documentation/swiftui/viewmodifier
/// A ViewModifier for macOS to provide a back button for navigating one view back.
/// Note: On macOS, `navigationBarBackButtonHidden` can be buggy, sometimes displaying the back button even when set to `true`.
struct NavigationBackButtonModifier: ViewModifier {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    var isDone: Bool

    /// Applies a view modifier that hides the navigation bar back button and  displays a dimiss Button
    ///
    /// - Parameter content: The content to which the modifier is applied.
    /// - Returns: The modified view with the navigation bar back button hidden and, if `isDone` is true, a toolbar item displayed.
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar(content: toolbarItem)
    }
    
    /// Dismiss Button
    private func toolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
            }
            .opacity(isDone ? 1 : 0)
        }
    }
}
