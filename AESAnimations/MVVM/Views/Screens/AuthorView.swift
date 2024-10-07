//
//  AuthorView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 07.10.24.
//

import SwiftUI

struct AuthorView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("selectedPrimaryColor") private var selectedPrimaryColor: PrimaryColor = .blue
    
    // MARK: -
    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            Image("hs-aalen-logo")
                .frame(maxWidth: .infinity)
                .scaledToFit()
            
            
            
            Text("Die App wurde von **Leon Chamoun** im Rahmen einer Bachelorarbeit entwickelt, die von **Prof. Dr. Christoph Karg** betreut wurde.")
                .multilineTextAlignment(.center)

            CustomButton<Never>(title: "Close", useMaxWidth: false) {
                dismiss()
            }
            
        }
        .accentColor(selectedPrimaryColor.color)
        .padding(20)
    }
}

#Preview {
    AuthorView()
}
