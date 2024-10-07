//
//  NavigationBackButtonModifier.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 06.10.24.
//

import SwiftUI

struct NavigationBackButtonModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    var isDone: Bool

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                if isDone {
                    ToolbarItem(placement: .navigation) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                        }
                    }
                }
            }
    }
}
