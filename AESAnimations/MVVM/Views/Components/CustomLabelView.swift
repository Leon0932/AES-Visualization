//
//  CustomLabelView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.10.24.
//

import SwiftUI

/// Helper view for displaying a title and an icon arranged horizontally.
struct CustomLabelView: View {
    // MARK: - Properties
    let title: LocalizedStringKey?
    let icon: String?
    
    // MARK: - Body
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
