//
//  SheetContainerView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 29.10.24.
//

import SwiftUI

struct SheetContainerView<Content: View>: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settingsVM: SettingsViewModel
    
    let navigationTitle: String
    let content: Content
    
    // MARK: - Initializer
    init(navigationTitle: String,
         @ViewBuilder content: () -> Content) {
        
        self.navigationTitle = navigationTitle
        self.content = content()
    }
    
    // MARK: -
    var body: some View {
        NavigationStack {
            Group {
#if os(macOS)
                VStack(spacing: 20) {
                    navigationTitleMac
                    content
                    
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .top)
#else
                content
#endif
            }
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(navigationTitle)
            .toolbar { closeButton { dismiss() } }
#endif
            .accentColor(settingsVM.primaryColor.color)
        }
    }
    
    // MARK: - Title macOs
    private var navigationTitleMac: some View {
        ZStack(alignment: .leading) {
            CustomButtonView(icon: "xmark",
                             buttonStyle: StandardButtonStyle(font: .title2)) {
                dismiss()
            }
            
            Text(navigationTitle)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.headline)
        }
    }
}
