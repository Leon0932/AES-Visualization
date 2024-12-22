//
//  HSAalenLogo.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 08.11.24.
//

import SwiftUI

/// A helper view for displaying the logo of Aalen University.
struct HSAalenLogo: View {
    // MARK: - Properties
    @Environment(\.locale) var locale
    
    var width: CGFloat = 500
    var height: CGFloat = 150
    
    // MARK: - Body
    var body: some View {
        Image(locale == Locale(identifier: "de") ? "hs-aalen-logo-de" : "hs-aalen-logo-en")
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
    }
}

#Preview {
    HSAalenLogo()
}
