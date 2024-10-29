//
//  AppDelegate.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 26.10.24.
//

import SwiftUI

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
            return (1300, 800)
        } else {
            return (1200, 750)
        }
    }
}
#endif
