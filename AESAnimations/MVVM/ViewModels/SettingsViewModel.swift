//
//  SettingsViewModel.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 27.10.24.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("colorScheme") var colorScheme: AppScheme = .system
    @AppStorage("primaryColor") var primaryColor: PrimaryColor = .blue
    
    func updateScheme() {
        #if os(iOS)
        if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow {
            window.overrideUserInterfaceStyle = colorScheme == .dark ? .dark : (colorScheme == .light ? .light : .unspecified)
        }
        #else
        if colorScheme == .system {
            NSApp.appearance = nil
        } else {
            NSApp.appearance = NSAppearance(named: colorScheme == .dark ? .darkAqua : .aqua)
        }
        #endif
    }
}
