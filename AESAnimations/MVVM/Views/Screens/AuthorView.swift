//
//  AuthorView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 07.10.24.
//

import SwiftUI

struct AuthorView: View {
    @Environment(\.dismiss) var dismiss
    
    #if os(iOS)
    @State private var showSafariView: Bool = false
    #endif
    
    var message: LocalizedStringKey {
        "Die App wurde von **Leon Chamoun** im Rahmen einer Bachelorarbeit entwickelt, die von **Prof. Dr. Christoph Karg** betreut wurde."
    }
    
    var buttonTitle: LocalizedStringKey {
        "FIPS PUB 197 (Version 2023)"
    }
    
    var destination: String {
        "https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197-upd1.pdf"
    }
    
    // MARK: -
    var body: some View {
        SheetContainerView(navigationTitle: "Urheber der App") {
            VStack(alignment: .center, spacing: 25) {
                HSAalenLogo()
                
                Text(message)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 15)
                
                
                VStack(spacing: 5) {
                    Text("Die Implementierung des AES basiert auf der Spezifikation des")
                        .multilineTextAlignment(.center)
                    
                    #if os(iOS)
                    CustomButtonView(title: buttonTitle, buttonStyle: .standard) {
                        showSafariView = true
                    }
                    #else
                    if let validURL = URL(string: destination) {
                        Link(buttonTitle, destination: validURL)
                    } else {
                        Link(buttonTitle, destination: URL(string: "https://google.com")!)
                    }
                    #endif
                }
            }
            #if os(iOS)
            .sheet(isPresented: $showSafariView) {
                SafariWebViewWrapper(urlString: destination)
            }
            #endif
        }
    }
}

#Preview {
    AuthorView()
}


