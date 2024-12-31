//
//  ViewExtensions.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import SwiftUI

extension View {
    /// Adds a "X" button to the toolbar.
    ///
    /// This function places a "X" button on the left side (`topBarLeading` is not avaible on macOS) of the toolbar area.
    /// The button performs the specified action when tapped.
    ///
    /// - Parameter action: The action to be executed when the button is tapped.
    /// - Returns: A `ToolbarContent` instance representing the "X" button
    func closeButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: {
            #if os(iOS)
            .topBarLeading
            #else
            .automatic
            #endif
        }()) {
            CustomButtonView(icon: "xmark",
                             buttonStyle: .standard,
                             action: action)
        }
    }
    
    // MARK: - View Modifiers
    /// Functions for creating custom view modifiers.
    /// Source: https://developer.apple.com/documentation/swiftui/viewmodifier
    
    /// Applies a platform-specific navigation modifier.
    ///
    /// This function adds a modifier to handle navigation behavior based on the platform (iOS or macOS).
    ///
    /// - Parameters:
    ///   - isPresented: A binding that determines whether the destination view is presented.
    ///   - destination: A closure that creates the destination view.
    /// - Returns: A view with the platform-specific navigation behavior applied.
    func specificNavigation<Destination: View>(isPresented: Binding<Bool>,
                                               destination: @escaping () -> Destination) -> some View {
        modifier(PlatformSpecificNavigationModifier(isPresented: isPresented, destination: destination))
    }
    
    /// Adds a custom back button to the navigation bar.
    ///
    /// This function applies a modifier to display a customizable back button in the navigation bar.
    ///
    /// - Parameter isDone: A Boolean value indicating whether the back button represents a "done" action. Default is `true`.
    /// - Returns: A view with the custom back button modifier applied.
    func customNavigationBackButton(isDone: Bool = true) -> some View {
        modifier(NavigationBackButtonModifier(isDone: isDone))
    }
    
    /// Adds a press effect to the view.
    ///
    /// This function applies a modifier that visually indicates when a view is pressed.
    ///
    /// - Parameter isPressed: A Boolean value indicating whether the view is being pressed.
    /// - Returns: A view with the press effect applied.
    func pressEffect(isPressed: Bool) -> some View {
        modifier(PressEffectModifier(isPressed: isPressed))
    }
    
    /// Adds a highlight effect when the view is hovered over.
    ///
    /// This function applies a modifier that visually highlights the view when the user's pointer hovers over it.
    ///
    /// - Parameter isHovered: A binding that tracks whether the view is currently hovered over.
    /// - Returns: A view with the highlight effect applied.
    func highlightEffect(isHovered: Binding<Bool>) -> some View {
        modifier(HighlightEffectModifier(isHovered: isHovered))
    }
    
    /// Tracks the position of a component in a view.
    ///
    /// This method applies a `PositionTrackingModifier` to the view, allowing the position of the component
    /// to be tracked and returned as a `Position` object. The position is calculated in the global coordinate space.
    ///
    /// - Parameter onPosition: A closure that receives the tracked position (`Position`) of the view as an argument.
    ///                         This closure is called whenever the position of the view changes.
    /// - Returns: A modified view with position tracking applied.
    func trackPosition(onPosition: @escaping (Position) -> Void) -> some View {
        modifier(PositionTrackingModifier(onPosition: onPosition))
    }
}
