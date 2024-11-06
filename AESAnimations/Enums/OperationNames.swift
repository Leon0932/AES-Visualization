//
//  AESOperations.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.08.24.
//

import Foundation
import SwiftUI

enum OperationNames: CustomStringConvertible {
    case shiftRows, subBytes, mixColumns, addRoundKey, keyExpansion, encryptionProcess, decryptionProcess, invSBox, sBox
    
    var description: String {
        let languageCode = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"

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
            return languageCode == "de" ? "Inverse S-Box Erstellung" : "Inverse S-Box creation"
        case .sBox:
            return languageCode == "de" ? "S-Box Erstellung" : "S-Box creation"
        }
    }
}
