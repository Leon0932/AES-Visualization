//
//  CustomLabelView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.10.24.
//

import SwiftUI

struct CustomLabelView: View {
    let title: LocalizedStringKey?
    let icon: String?
    
    var body: some View {
        HStack {
            if let icon {
                Image(systemName: icon)
            }
            
            if let title {
                Text(title)
            }
        }
    }
}
