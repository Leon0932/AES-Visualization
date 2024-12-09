//
//  CustomNavigationButton.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.10.24.
//

import SwiftUI

/// A navigation button that displays a text, an icon, or both
struct CustomNavigationButton<Content: View, Style: ButtonStyle>: View {
    // MARK: - Properties
    var title: LocalizedStringKey? = nil
    var icon: String? = nil
    let buttonStyle: Style
    let destination: () -> Content
    
    // MARK: - Body
    var body: some View {
        NavigationLink(destination: destination()) {
            CustomLabelView(title: title, icon: icon)
        }
        .buttonStyle(buttonStyle)
    }
}
