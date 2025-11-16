//
//  CustomToolbarToggle.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 15.11.25.
//

import SwiftUI

struct CustomToolbarToggle: View {
    var title: LocalizedStringKey
    @Binding var isOn: Bool
   
    var body: some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            Button(title) {
                isOn.toggle()
            }
        } else {
            Toggle(title, isOn: $isOn)
                .buttonStyle(.plain)
        }
    }
}
