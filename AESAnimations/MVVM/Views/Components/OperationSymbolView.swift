//
//  OperationSymbolView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.08.24.
//

import SwiftUI

/// A component for animating and displaying an operation.
struct OperationSymbolView: View {
    // MARK: - Properties
    var text: String
    var isVisible: Double
    var leadingPadding: CGFloat = 0
    
    // MARK: -
    var body: some View {
        Text(text)
            .font(.system(size: 34, weight: .bold)) /// iOS and macOS don't share the same sizes in SwiftUI (`.title` for example)
            .padding(.leading, leadingPadding)
            .opacity(isVisible)
    }
}
