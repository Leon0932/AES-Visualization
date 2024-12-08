//
//  MainViewModel.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 15.08.24.
//

import SwiftUI

class MainViewModel: ObservableObject {
    // MARK: - Properties
    @AppStorage("showMainView") var showMainView: Bool = false
    @Published var showSafariView: Bool = false
    
    @Published var selectedEncryptionMode: AESConfiguration = .key128
    
    @Published var stateMatrix = Matrix(rows: 4, columns: 4)
    @Published var keyMatrix = Matrix(rows: 4, columns: 4)
    
    @Published var showSettings = false
    @Published var showAuthor = false
    
    // MARK: - View-Functions
    func handlePickerChange(newValue: AESConfiguration) {
        withAnimation {
            keyMatrix = Matrix(rows: 4, columns: newValue.rawValue)
        }
    }
    
    func createProcessViewModel(isDecryption: Bool) -> ProcessViewModel {
        let state = AESState()
        let keySched = AESKeySchedule()
        
        let cipher = AESCipher(keySchedule: keySched, state: state)
        cipher.set(input: stateMatrix.data.hexStringTo2DByteArray(),
                   key: keyMatrix.data.toByteArray())

        isDecryption ? cipher.decryptState() : cipher.encryptState()
        
        let operationDetails = OperationDetails(operationName: isDecryption ? .decryptionProcess : .encryptionProcess,
                                                isInverseMode: isDecryption ? true : false,
                                                currentRound: -1)
        
        return ProcessViewModel(operationDetails: operationDetails,
                                aesState: state,
                                aesCipher: cipher,
                                showCipherButton: true)
    }
    
    func toggleAuthor() {
        showAuthor.toggle()
    }
    
    func toggleSettings() {
        showSettings.toggle()
    }
}

