//
//  HighlightEffectModifier.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.10.24.
//

import SwiftUI

struct HighlightEffectModifier: ViewModifier {
    @Binding var isHovered: Bool
    
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
