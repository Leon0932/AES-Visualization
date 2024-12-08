//
//  AuthorMessage.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 30.11.24.
//

import SwiftUI

struct AuthorMessage: View {
    // MARK: - Properties
    @Binding var showSafariView: Bool
    
    // MARK: - Computed Helper Properties
    var message: LocalizedStringKey {
        "Die App wurde von **Leon Chamoun** im Rahmen einer Bachelorarbeit entwickelt, die von **Prof. Dr. Christoph Karg** betreut wurde."
    }
    
    var buttonTitle: LocalizedStringKey {
        "FIPS 197 (Version 2023)"
    }
    
    var destination: String {
        "https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197-upd1.pdf"
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 25) {
            Text(message)
                .multilineTextAlignment(.center)
            
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
