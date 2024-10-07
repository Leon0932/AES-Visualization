//
//  ColorSchemeOptions.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 06.08.24.
//

import Foundation

enum ColorSchemeOption: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { self.rawValue }
}
