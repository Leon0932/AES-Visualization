//
//  HSAalenLogo.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 08.11.24.
//

import SwiftUI

struct HSAalenLogo: View {
    @Environment(\.locale) var locale
    
    var width: CGFloat = 500
    var height: CGFloat = 150
    
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
