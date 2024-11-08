//
//  HSAalenLogo.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 08.11.24.
//

import SwiftUI

struct HSAalenLogo: View {
    @Environment(\.locale) var locale
    
    var body: some View {
        Image(locale == Locale(identifier: "en") ? "hs-aalen-logo-en" : "hs-aalen-logo-de")
            .frame(maxWidth: .infinity)
            .scaledToFit()
    }
}

#Preview {
    HSAalenLogo()
}
