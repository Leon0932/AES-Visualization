//
//  SettingsViewModel.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 27.10.24.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage(StorageKeys.colorScheme.key) var colorScheme: AppScheme = .system
    @AppStorage(StorageKeys.primaryColor.key) var primaryColor: PrimaryColor = .blue
    @AppStorage(StorageKeys.appLanguage.key) var appLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    @AppStorage(StorageKeys.includeReverseAnimation.key) var includeReverseAnimation: Bool = true
    
    @Published var showAlert = false
    
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
    
    func changeLanguage() {
        appLanguage = (appLanguage == "en") ? "de" : "en"
    }
}
