//
//  AESAnimationsApp.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 06.07.24.
//

import SwiftUI

@main
struct AESAnimationsApp: App {
    @StateObject var settingsViewModel = SettingsViewModel()
    
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(settingsViewModel)
                .tint(settingsViewModel.primaryColor.color)
                .accentColor(settingsViewModel.primaryColor.color)
                #if os(macOS)
                .frame(width: 1300, height: 800)
                #endif
                .onChange(of: settingsViewModel.colorScheme) { settingsViewModel.updateScheme() }
        }
    }
}
