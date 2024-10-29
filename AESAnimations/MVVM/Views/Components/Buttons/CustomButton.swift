//
//  CustomButton.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import SwiftUI

struct CustomButtonView<Style: ButtonStyle>: View {
    // MARK: - Properties
    var title: String? = nil
    var icon: String? = nil
    let buttonStyle: Style
    let action: () -> Void
    
    // MARK: -
    var body: some View {
        Button(action: action) {
            CustomLabelView(title: title, icon: icon)
        }
        .buttonStyle(buttonStyle)
    }
}
