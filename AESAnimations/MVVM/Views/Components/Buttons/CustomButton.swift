//
//  CustomButton.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import SwiftUI

/// A button that displays a text, an icon, or both
struct CustomButton<Style: ButtonStyle>: View {
    // MARK: - Properties
    var title: LocalizedStringKey? = nil
    var icon: String? = nil
    let buttonStyle: Style
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            CustomLabel(title: title, icon: icon)
        }
        .buttonStyle(buttonStyle)
    }
}
