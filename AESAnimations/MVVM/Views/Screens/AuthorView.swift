//
//  AuthorView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 07.10.24.
//

import SwiftUI

struct AuthorView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var showSafariView: Bool = false
    
    // MARK: -
    var body: some View {
        SheetContainerView(navigationTitle: "Urheber der App") {
            VStack(alignment: .center, spacing: 25) {
                HSAalenLogo(width: 400)
                AuthorMessage(showSafariView: $showSafariView)
            }
        }
    }
}

#Preview {
    AuthorView()
}


