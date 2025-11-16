//
//  SettingsConfigurations.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 11/6/24.
//

import Foundation

/// Represents different configuration categories within the app's settings.
enum SettingsConfigurations {
    case language
    case appearance
    #if os(iOS)
    case color
    #endif
    case others
}
