//
//  WarningView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 08.12.24.
//

import SwiftUI

struct WarningView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 50) {
            
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.circle.fill")
                Text("Warnung")
            }
            .font(.system(size: 75, weight: .bold))
            .foregroundStyle(Color.red)
            
            
            Text("Diese App ist NICHT für iPad Mini verfügbar.")
                .font(.system(size: 40))
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    WarningView()
}
