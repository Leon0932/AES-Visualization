//
//  AppStorageKeys.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 09.11.24.
//

import SwiftUI

enum StorageKeys: String {
    case appLanguage
    case colorScheme
    case primaryColor
    case includeReverseAnimation
    case startAnimationOnAppear
    
    var key: String { rawValue }
}
