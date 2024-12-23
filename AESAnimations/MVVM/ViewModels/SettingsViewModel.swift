//
//  SettingsViewModel.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 27.10.24.
//

import SwiftUI

/// ViewModel to store user-preferred settings
final class SettingsViewModel: ObservableObject {
    // MARK: - Properties
    @AppStorage(StorageKeys.colorScheme.key) var colorScheme: AppScheme = .system
    @AppStorage(StorageKeys.primaryColor.key) var primaryColor: PrimaryColor = .blue
    @AppStorage(StorageKeys.appLanguage.key) var appLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    @AppStorage(StorageKeys.includeReverseAnimation.key) var includeReverseAnimation: Bool = false
    @AppStorage(StorageKeys.startAnimationOnAppear.key) var startAnimationOnAppear: Bool = false
    
    @Published var showAuthorView = false
    
    // MARK: - Initializer
    /// Checks if the data is stored in `UserDefaults`
    /// After installing the app, the data is not stored in `UserDefaults`.
    /// It also checks if the data is `nil`, otherwise the app crashes.
    init() {
        if UserDefaults.standard.object(forKey: StorageKeys.colorScheme.key) == nil {
            UserDefaults.standard.set(colorScheme.rawValue, forKey: StorageKeys.colorScheme.key)
        }
        if UserDefaults.standard.object(forKey: StorageKeys.primaryColor.key) == nil {
            UserDefaults.standard.set(primaryColor.rawValue, forKey: StorageKeys.primaryColor.key)
        }
        if UserDefaults.standard.object(forKey: StorageKeys.appLanguage.key) == nil {
            UserDefaults.standard.set(appLanguage, forKey: StorageKeys.appLanguage.key)
        }
        if UserDefaults.standard.object(forKey: StorageKeys.includeReverseAnimation.key) == nil {
            UserDefaults.standard.set(includeReverseAnimation, forKey: StorageKeys.includeReverseAnimation.key)
        }
        if UserDefaults.standard.object(forKey: StorageKeys.startAnimationOnAppear.key) == nil {
            UserDefaults.standard.set(startAnimationOnAppear, forKey: StorageKeys.startAnimationOnAppear.key)
        }
    }
    
    /// Helper function to update the scheme based on the current setting 
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
