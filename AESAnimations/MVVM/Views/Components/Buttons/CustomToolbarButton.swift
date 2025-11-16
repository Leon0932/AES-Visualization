//
//  CustomToolbarButton.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 15.11.25.
//

import SwiftUI

struct CustomToolbarButton<Style: ButtonStyle>: View {
    // MARK: - Properties
    var title: LocalizedStringKey = ""
    var icon: String? = nil
    var buttonStyle: Style
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Group {
            if #available(iOS 26.0, macOS 26.0, *) {
                if icon == nil {
                    Button(title, action: action)
                } else if let icon {
                    Button(title, systemImage: icon, action: action)
                }
            } else {
                CustomButton(icon: icon,
                             buttonStyle: buttonStyle,
                             action: action)
            }
        }
    }
}
