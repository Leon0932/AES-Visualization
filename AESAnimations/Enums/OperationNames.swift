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
            switch self {
            case .shiftRows:
                return NSLocalizedString("ShiftRows", comment: "")
            case .subBytes:
                return NSLocalizedString("SubBytes", comment: "")
            case .mixColumns:
                return NSLocalizedString("MixColumns", comment: "")
            case .addRoundKey:
                return NSLocalizedString("AddRoundKey", comment: "")
            case .keyExpansion:
                return NSLocalizedString("KeyExpansion", comment: "")
            case .encryptionProcess:
                return NSLocalizedString("Verschlüsselungsprozess", comment: "")
            case .decryptionProcess:
                return NSLocalizedString("Entschlüsselungsprozess", comment: "")
            case .invSBox:
                return NSLocalizedString("Inverse S-Box Erstellung", comment: "")
            case .sBox:
                return NSLocalizedString("S-Box Erstellung", comment: "")
            }
        }
}
