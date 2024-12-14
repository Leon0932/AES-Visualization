//
//  MainViewModel.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 15.08.24.
//

import SwiftUI

final class MainViewModel: ObservableObject {
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
        let cipher = AESCipher(input: stateMatrix.data.to2DByteArray(),
                               key: keyMatrix.data.to2DByteArray())

        isDecryption ? cipher.decryptState() : cipher.encryptState()
        
        let operationDetails = OperationDetails(operationName: isDecryption ? .decryptionProcess : .encryptionProcess,
                                                isInverseMode: isDecryption ? true : false,
                                                currentRound: -1)
        
        return ProcessViewModel(operationDetails: operationDetails,
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

