//
//  AESOperations.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.08.24.
//

import Foundation
import SwiftUI

/// Navigation titles for the Animation Views.
/// On macOS, language support is not integrated automatically, so titles may
/// need to be manually set in both English and German.
enum OperationNames: CustomStringConvertible {
    case shiftRows, subBytes, mixColumns, addRoundKey, keyExpansion, encryptionProcess, decryptionProcess, invSBox, sBox, subWord
    
    var description: String {
        let languageCode = UserDefaults.standard.string(forKey: StorageKeys.appLanguage.key) ?? "en"

        switch self {
        case .shiftRows:
            return "ShiftRows"
        case .subBytes:
            return "SubBytes"
        case .mixColumns:
            return "MixColumns"
        case .addRoundKey:
            return "AddRoundKey"
        case .keyExpansion:
            return "KeyExpansion"
        case .encryptionProcess:
            return languageCode == "de" ? "Verschlüsselungsprozess" : "Encryption Process"
        case .decryptionProcess:
            return languageCode == "de" ? "Entschlüsselungsprozess" : "Decryption Process"
        case .invSBox:
            return languageCode == "de" ? "Inverse S-Box Erstellung" : "Inverse S-Box Creation"
        case .sBox:
            return languageCode == "de" ? "S-Box Erstellung" : "S-Box Creation"
        case .subWord:
            return "SubWord"
        }
    }
}
