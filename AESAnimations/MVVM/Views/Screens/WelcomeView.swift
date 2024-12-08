//
//  WelcomeView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 30.11.24.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var showMainView: Bool
    @Binding var showSafariView: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            content
        }
        .padding(.top, 50)
        .frame(width: 1000, alignment: .top)
    }
    
    @ViewBuilder
    var content: some View {
        VStack(spacing: 15) {
            Image("AppIconWelcome")
                .resizable()
                .frame(width: 200, height: 200)
            
            Text("Willkommen zu **AES-Visualization**")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            
            Text("Erlebe AES-Verschlüsselung wie nie zuvor – interaktive Visualisierung der Algorithmen, klar verständlich und perfekt für Studium oder Entwicklung!")
                .font(.body)
                .multilineTextAlignment(.center)
        }
        
        Spacer()
        
        HSAalenLogo()
        AuthorMessage(showSafariView: $showSafariView)
        
        Spacer()
        
        CustomButtonView(title: "Starten",
                         buttonStyle: PrimaryButtonStyle(useMaxWidth: true)) {
            withAnimation {
                showMainView = true
            }
        }
                         .padding(.bottom, 25)
    }
}
