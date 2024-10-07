//
//  ViewExtensions.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import SwiftUI

extension View {
    func boxSize() -> CGFloat {
        #if os(iOS)
        return isPad13Size() ? 40 : 35
        #elseif os(macOS)
        return 37
        #else
        return 35
        #endif
    }
    
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
            Button(action: action) {
                Image(systemName: "xmark")
                    .foregroundColor(.accentColor)
            }
        }
    }
    
    func platformSpecificNavigation<Destination: View>(isPresented: Binding<Bool>,
                                                       destination: @escaping () -> Destination) -> some View {
        self.modifier(PlatformSpecificNavigationModifier(isPresented: isPresented, destination: destination))
    }
    
    func customNavigationBackButton(isDone: Bool = true) -> some View {
           self.modifier(NavigationBackButtonModifier(isDone: isDone))
       }
}
