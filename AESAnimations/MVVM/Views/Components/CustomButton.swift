//
//  CustomButton.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import SwiftUI


struct CustomButton<Content: View>: View {
    // MARK: - Properties
    let title: String
    var icon: String? = nil
    var useMaxWidth: Bool = true
    var isDisabled: Bool = false
    var destination: (() -> Content)? = nil
    let action: () -> Void
    
    // MARK: -
    var body: some View {
        Group {
            if let destination = destination {
                NavigationLink(destination: destination()) {
                    buttonContent
                }
            } else {
                Button(action: action) {
                    buttonContent
                }
            }
        }
        .disabled(isDisabled)
        #if os(macOS)
        .buttonStyle(.plain)
        #endif
    }
    
    // MARK: - Button Content
    private var buttonContent: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
            }
            Text(title)
        }
        .font(.headline)
        .foregroundColor(.white)
        .frame(maxWidth: useMaxWidth ? .infinity : nil)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isDisabled ? Color.gray : Color.accentColor)
        )
    }
}
