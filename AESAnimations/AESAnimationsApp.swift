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
            content
        }
    }

    var content: some View {
        Group {
            #if os(iOS)
            if DeviceDetector.isiPadMini() {
                WarningView()
            } else {
                mainContent
            }
            #else
            mainContent
            #endif
        }
    }

    var mainContent: some View {
        MainView()
            .environmentObject(settingsViewModel)
            .tint(settingsViewModel.primaryColor.color)
            .accentColor(settingsViewModel.primaryColor.color)
            #if os(macOS)
            .frame(width: 1300, height: 800)
            #endif
            .environment(\.locale, .init(identifier: settingsViewModel.appLanguage))
            .onChange(of: settingsViewModel.colorScheme) { settingsViewModel.updateScheme() }
            .onAppear(perform: settingsViewModel.updateScheme) // Ensures color scheme is updated on app launch
    }
}
