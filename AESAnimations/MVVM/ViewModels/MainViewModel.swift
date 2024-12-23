//
//  MainViewModel.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 15.08.24.
//

import SwiftUI

/// ViewModel for processing input data and
/// creating the AES Process ViewModel (`ProcessViewModel`)
final class MainViewModel: ObservableObject {
    // MARK: - Properties
    @AppStorage("showMainView") var showMainView: Bool = false
    @Published var showSafariView: Bool = false
    
    @Published var selectedEncryptionMode: AESConfiguration = .key128
    
    @Published var stateMatrix = Matrix(rows: 4, columns: 4)
    @Published var keyMatrix = Matrix(rows: 4, columns: 4)
    
    @Published var showSettings = false
    
    // MARK: - View-Functions
    
    /// Updates the matrix of key inputs for AES encryption (AES-128, AES-192, and AES-256).
    /// - Parameter newValue: The new column value to be set in the matrix.
    func handlePickerChange(newValue: AESConfiguration) {
        withAnimation {
            keyMatrix = Matrix(rows: 4, columns: newValue.rawValue)
        }
    }
    
    /// Creates a `ProcessViewModel` for either encryption or decryption.
    ///
    /// This function initializes an AESCipher with the given state and key matrices to
    /// encrypt or decrypt the state based on the isDecryption flag.
    /// It returns a ProcessViewModel with the cipher and operation details.
    ///
    /// - Parameter isDecryption: A Boolean flag indicating whether the operation is decryption (`true`) or encryption (`false`).
    /// - Returns: A `ProcessViewModel` containing details of the encryption or decryption process, including the configured AES cipher.
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
    
    /// Helper function to show the `SettingsView` in a sheet
    func toggleSettings() {
        showSettings.toggle()
    }
}

