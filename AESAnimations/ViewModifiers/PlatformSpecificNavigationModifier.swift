//
//  PlatformSpecificNavigationModifier.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 29.09.24.
//

import SwiftUI

struct PlatformSpecificNavigationModifier<Destination: View>: ViewModifier {
    @Binding var isPresented: Bool
    let destination: () -> Destination
    
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

