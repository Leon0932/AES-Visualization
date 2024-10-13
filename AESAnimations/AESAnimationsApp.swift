//
//  AESAnimationsApp.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 06.07.24.
//

import SwiftUI
import TipKit

@main
struct AESAnimationsApp: App {
    @AppStorage("selectedColorScheme") private var selectedColorScheme: AppScheme = .device
    @AppStorage("selectedPrimaryColor") private var selectedPrimaryColor: PrimaryColor = .blue
    
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .tint(selectedPrimaryColor.color)
                .accentColor(selectedPrimaryColor.color)
                #if os(macOS)
                .frame(width: 1300, height: 800)
                .preferredColorScheme(selectedColorScheme == .device ? nil : selectedColorScheme == .dark ? .dark : .light)
                #else
                .onChange(of: selectedColorScheme) { _, _ in
                    updateScheme()
                }
                #endif
        }
        
        #if os(macOS)
        Window("Settings", id: "settings") {
            SettingsView()
        }
        #endif
    }
    
    #if os(iOS)
    private func updateScheme() {
        if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow {
            window.overrideUserInterfaceStyle =
            selectedColorScheme == .dark
            ? .dark
            : selectedColorScheme == .light ? .light : .unspecified
        }
    }
    #endif
    
}

#if os(macOS)
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        configureMainWindow()
    }
    
    private func configureMainWindow() {
        guard let window = NSApplication.shared.windows.first else { return }
        
        let screenSize = NSScreen.main?.frame.size ?? defaultScreenSize
        let (windowWidth, windowHeight) = optimalWindowSize(for: screenSize.width)
        
        window.setContentSize(NSSize(width: windowWidth, height: windowHeight))
        window.minSize = NSSize(width: windowWidth, height: windowHeight)
        window.maxSize = NSSize(width: windowWidth, height: windowHeight)
    }
    
    private var defaultScreenSize: NSSize {
        NSSize(width: 1280, height: 800)
    }
    
    private func optimalWindowSize(for screenWidth: CGFloat) -> (CGFloat, CGFloat) {
        if screenWidth > 1280 {
            return (1300, 800) // Größere Fenstergröße für größere Bildschirme
        } else {
            return (1200, 750) // Kleinere Fenstergröße für 13-Zoll-MacBooks und ähnliche Bildschirme
        }
    }
}
#endif
