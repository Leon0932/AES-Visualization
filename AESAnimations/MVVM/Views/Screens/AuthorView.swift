//
//  AuthorView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 07.10.24.
//

import SwiftUI

struct AuthorView: View {
    @Environment(\.dismiss) var dismiss
    
    var message: LocalizedStringKey {
        "Die App wurde von **Leon Chamoun** im Rahmen einer Bachelorarbeit entwickelt, die von **Prof. Dr. Christoph Karg** betreut wurde."
    }
    
    // MARK: -
    var body: some View {
        SheetContainerView(navigationTitle: "Urheber der App") {
            VStack(alignment: .center, spacing: 25) {
                Image("hs-aalen-logo")
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
                
                Text(message)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 25)
                
            }
        }
    }
}

#Preview {
    AuthorView()
}


