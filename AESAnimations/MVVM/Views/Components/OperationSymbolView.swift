//
//  OperationSymbolView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.08.24.
//

import SwiftUI

struct OperationSymbolView: View {
    // MARK: - Properties
    var text: String
    var isVisible: Double
    var leadingPadding: CGFloat = 0
    
    // MARK: -
    var body: some View {
        Text(text)
            .font(.system(size: 34, weight: .bold))
            .padding(.leading, leadingPadding)
            .opacity(isVisible)
    }
}
