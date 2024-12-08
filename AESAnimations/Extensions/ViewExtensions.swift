//
//  ViewExtensions.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import SwiftUI

extension View {
    #if os(iOS)
    func isPad13Size() -> Bool {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let maxDimension = max(screenWidth, screenHeight)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return maxDimension >= 1366 ? true : false
        }
        return false
    }
    #endif
    
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
    func specificNavigation<Destination: View>(isPresented: Binding<Bool>,
                                               destination: @escaping () -> Destination) -> some View {
        self.modifier(PlatformSpecificNavigationModifier(isPresented: isPresented, destination: destination))
    }
    
    func customNavigationBackButton(isDone: Bool = true) -> some View {
        self.modifier(NavigationBackButtonModifier(isDone: isDone))
    }
    
    func pressEffect(isPressed: Bool) -> some View {
        self.modifier(PressEffectModifier(isPressed: isPressed))
    }
    
    func highlightEffect(isHovered: Binding<Bool>) -> some View {
        self.modifier(HighlightEffectModifier(isHovered: isHovered))
    }
}
