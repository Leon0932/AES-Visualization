//
//  AESConfiguration.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 30.07.24.
//

import Foundation

/// Represents the key size, number of rounds, and a descriptive label.
enum AESConfiguration: Int, CaseIterable, Identifiable {
    // Identifier for use in UI or other cases
    var id: String { self.label }
    var nb: Int { 4 }
    
    case key128 = 4
    case key192 = 6
    case key256 = 8

    var rounds: Int {
        switch self {
        case .key128: return 10
        case .key192: return 12
        case .key256: return 14
        }
    }

    var label: String {
        switch self {
        case .key128: return "AES-128"
        case .key192: return "AES-192"
        case .key256: return "AES-256"
        }
    }
}
