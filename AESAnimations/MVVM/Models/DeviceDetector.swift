//
//  DeviceDetector.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 08.12.24.
//

import SwiftUI

/// A helper struct for detecting iPad devices.
struct DeviceDetector {
    /// Determines if the current iPad is a 13-inch model.
    ///
    /// This function checks the screen size of the iPad to determine if it matches the dimensions of a 13-inch iPad Pro.
    /// If the device is not an iPad or the screen size does not meet the 13-inch criteria, it returns `false`.
    ///
    /// - Returns: `true` if the device is an iPad and the screen size corresponds to a 13-inch iPad Pro, otherwise `false`.
    #if os(iOS)
    static func isPad13Size() -> Bool {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let maxDimension = max(screenWidth, screenHeight)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return maxDimension >= 1366 ? true : false
        }
        return false
    }
    
    /// Determines if the iPad is a Mini model.
    ///
    /// This function checks the screen size of the device to determine if it matches the dimensions of a 7.9-inch iPad Mini.
    /// It returns `true` if the device is an iPad and its screen size matches the known dimensions of the iPad Mini in portrait or landscape orientation.
    ///
    /// - Returns: `true` if the device is an iPad Mini, otherwise `false`.
    static func isiPadMini() -> Bool {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        // iPad Mini hat eine typische Breite und Höhe von ~744x1133 (9 Zoll)
        return max(screenHeight, screenWidth) <= 1133 && min(screenHeight, screenWidth) <= 744
    }
    #else
    static func isLargeWindow() -> Bool {
        if let keyWindow = NSApplication.shared.keyWindow {
            let frame = keyWindow.frame
            
            return frame.width >= 1500 && frame.height >= 900
        }
        return false
    }
    #endif
}
