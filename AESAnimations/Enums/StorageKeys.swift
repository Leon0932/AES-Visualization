//
//  AppStorageKeys.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 09.11.24.
//

import SwiftUI

/// Used for saved settings to eliminate the need for
/// string-based case handling.
enum StorageKeys: String {
    case appLanguage
    case colorScheme
    #if os(iOS)
    case primaryColor
    #endif
    case includeReverseAnimation
    case startAnimationOnAppear
    
    var key: String { rawValue }
}
