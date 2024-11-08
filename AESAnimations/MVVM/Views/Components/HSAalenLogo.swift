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
        Image(locale == Locale(identifier: "de") ? "hs-aalen-logo-de" : "hs-aalen-logo-en")
            .frame(maxWidth: .infinity)
            .scaledToFit()
    }
}

#Preview {
    HSAalenLogo()
}
