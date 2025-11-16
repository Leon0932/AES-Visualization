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
            #if os(iOS)
            .tint(settingsViewModel.primaryColor.color)
            #endif
            #if os(macOS)
            .frame(minWidth: 1200, minHeight: 700)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            #endif
            .environment(\.locale, .init(identifier: settingsViewModel.appLanguage))
            .onChange(of: settingsViewModel.colorScheme) { settingsViewModel.updateScheme() }
            .onAppear(perform: settingsViewModel.updateScheme) // Ensures color scheme is updated on app launch
    }
}
