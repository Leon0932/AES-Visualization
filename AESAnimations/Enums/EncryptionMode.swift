//
//  EncryptionMode.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 28.07.24.
//

import Foundation

enum EncryptionMode: String, CaseIterable, Identifiable {
    case aes128 = "AES-128"
    case aes192 = "AES-192"
    case aes256 = "AES-256"
    
    var id: String { self.rawValue }
    
    var keyMatrixColumns: Int {
        switch self {
        case .aes128:
            return 4
        case .aes192:
            return 6
        case .aes256:
            return 8
        }
    }
}
