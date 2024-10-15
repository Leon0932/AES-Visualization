//
//  MainViewModel.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 15.08.24.
//

import SwiftUI

class MainViewModel: ObservableObject {
    // MARK: - Properties
    @Published var selectedEncryptionMode: EncryptionMode = .aes128
    
    @Published var stateMatrix = Matrix(rows: 4, columns: 4)
    @Published var keyMatrix = Matrix(rows: 4, columns: 4)
    
    @Published var showKeyView = false
    @Published var showSettings = false
    @Published var showAuthor = false
    
    // MARK: - View-Functions
    func handleEncryptionModeChange(newValue: EncryptionMode) {
        keyMatrix = Matrix(rows: 4, columns: newValue.keyMatrixColumns)
    }
    
    func createProcessViewModel(isDecryption: Bool) -> ProcessViewModel {
        let state = AESState()
        let keySched = AESKeySchedule()
        
        let cipher = AESCipher(keySchedule: keySched,
                               state: state)
        
        cipher.set(input: stateMatrix.toByteArray(),
                   key: keyMatrix.toByteArray())
        
        isDecryption ? cipher.decryptState() : cipher.encryptState()
        
        return ProcessViewModel(operationDetails: OperationDetails(operationName: isDecryption ? .decryptionProcess : .encryptionProcess,
                                                                   isInverseMode: isDecryption ? true : false,
                                                                   currentRound: -1),
                                aesState: state,
                                aesCipher: cipher)
    }
}

