//
//  AESOperations.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.08.24.
//

import Foundation

enum OperationNames: CustomStringConvertible {
    case shiftRows, subBytes, mixColumns, addRoundKey, keyExpansion, encryptionProcess, decryptionProcess, invSBox, sBox
    
    var description: String {
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
            return "Verschlüsselungsprozess"
        case .decryptionProcess:
            return "Entschlüsselungsprozess"
        case .invSBox:
            return "Inverse S-Box Erstellung"
        case .sBox:
            return "S-Box Erstellung"
        }
    }
}
