//
//  CustomNavigationButton.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.10.24.
//

import SwiftUI

struct CustomNavigationButton<Content: View, Style: ButtonStyle>: View {
    // MARK: - Properties
    var title: LocalizedStringKey? = nil
    var icon: String? = nil
    let buttonStyle: Style
    let destination: () -> Content
    
    // MARK: -
    var body: some View {
        NavigationLink(destination: destination()) {
            CustomLabelView(title: title, icon: icon)
        }
        .buttonStyle(buttonStyle)
    }
}
