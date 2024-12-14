//
//  AESCipher.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 28.07.24.
//

import Foundation

final class AESCipher {
    // MARK: - Properties
    let keySchedule: AESKeySchedule
    let state: AESState
    
    private var input: [[Byte]] = []
    private var key: [[Byte]] = []
    private var result: [[Byte]] = []
    private var cipherHistory: [CipherRound] = []
    
    // MARK: - Initializer
    init(keySchedule: AESKeySchedule, state: AESState) {
        self.keySchedule = keySchedule
        self.state = state
    }
    
    // MARK: - Computed Properties
    /// Retrieves the number of rounds for the cipher based on the key size.
    ///
    /// This computed property returns the number of rounds used in the AES cipher,
    /// which is determined by the key size (AES-128, AES-192, or AES-256).
    ///
    /// - Returns: An `Int` representing the number of rounds for the cipher.
    var getNrOfRounds: Int { keySchedule.getNrOfRounds }

    /// Retrieves the round keys used during the cipher operation.
    ///
    /// This computed property returns an array of round keys that are generated
    /// during the key expansion process and used in each round of AES encryption or decryption.
    ///
    /// - Returns: A 2D array of `Byte` values representing the round keys.
    var getRoundKeys: [[Byte]] { keySchedule.getRoundKeys }

    /// Retrieves the size of the key used in the cipher operation.
    ///
    /// This computed property returns the size of the encryption key,
    /// typically represented as the number of 32-bit words (e.g., 4 for AES-128, 6 for AES-192, 8 for AES-256).
    ///
    /// - Returns: An `Int` representing the size of the key in terms of 32-bit words.
    var getNk: Int { keySchedule.getNk }

    /// Retrieves the history of cipher rounds during the encryption or decryption process.
    ///
    /// This computed property returns the complete history of the cipher process,
    /// with each round's transformation steps stored in a `CipherRound` object.
    ///
    /// - Returns: An array of `CipherRound` objects representing the history of the cipher rounds.
    var getCipherHistory: [CipherRound] { cipherHistory }
    
    /// Retrieves the final result of the cipher operation.
    ///
    /// This computed property returns the computed result of the cipher process, stored as a 2D array of `Byte` values.
    /// The result represents the current state of the encryption or decryption process.
    ///
    /// - Returns: A 2D array of `Byte` values representing the cipher result.
    var getResult: [[Byte]] { result }
    
    /// Retrieves the input for the cipher operation.
    ///
    /// This computed property returns the input data used in the encryption or decryption process,
    /// represented as an array of `Byte` values.
    ///
    /// - Returns: An array of `Byte` values representing the input.
    var getInput: [[Byte]] { input }

    /// Retrieves the key used for the cipher operation.
    ///
    /// This computed property returns the encryption or decryption key, represented as an array of `Byte` values.
    ///
    /// - Returns: An array of `Byte` values representing the key.
    var getKey: [[Byte]] { key }
    
    // MARK: - Helper functions
    /// Sets the input and key for the cipher operation.
    ///
    /// This function updates the current input and key values used for the encryption or decryption process.
    ///
    /// - Parameters:
    ///   - input: An array of `Byte` values representing the new input for the cipher.
    ///   - key: An array of `Byte` values representing the new key for the cipher.
    func set(input: [[Byte]], key: [[Byte]]) {
        self.input = input
        self.key = key
    }
    
    /// Expands the key and updates the result and cipher history.
    ///
    /// This function clears the `result` and `cipherHistory`, performs key expansion using the provided key,
    /// and converts the input into a state matrix stored in `result`.
    private func createKeyExpansion() {
        result = []
        cipherHistory = []
        
        keySchedule.keyExpansion(key: key)
        
        result = input
    }
    
    // MARK: - Main Operations
    /// Performs the encryption process on the current state using the AES algorithm.
    ///
    /// This function executes the AES encryption process step-by-step, using the previously expanded round keys.
    /// It iterates through each round of the AES algorithm, applying transformations such as SubBytes, ShiftRows,
    /// MixColumns, and AddRoundKey.
    ///
    /// The state of each round, including after each transformation step, is stored in `cipherHistory` as a series of `CipherRound` objects.
    func encryptState() {
        createKeyExpansion()
        
        let startKey = getRoundKeys[0].convertToState()
        
        var startRound = CipherRound(index: 0, startOfRound: result, roundKey: startKey)
        state.addRoundKey(state: &result, key: startKey)
        startRound.afterAddRound = result
        
        cipherHistory.append(startRound)
        
        for round in 1..<getNrOfRounds {
            var cipherRound = CipherRound(index: round, startOfRound: result)
            
            state.subBytes(state: &result, isInverse: false)
            
            cipherRound.afterSubBytes = result
            
            _ = state.shiftRows(state: &result, isInverse: false)
            
            cipherRound.afterShiftRows = result
            
            state.mixColumns(state: &result, isInverse: false)
            
            cipherRound.afterMixColumns = result
            
            let roundKey = getRoundKeys[round].convertToState()
            
            state.addRoundKey(state: &result, key: roundKey)
            
            cipherRound.afterAddRound = result
            
            cipherRound.roundKey = roundKey
            
            cipherHistory.append(cipherRound)
        }
        
        var cipherRound = CipherRound(index: getNrOfRounds, startOfRound: result)
        
        state.subBytes(state: &result, isInverse: false)
        cipherRound.afterSubBytes = result
        
        _ = state.shiftRows(state: &result, isInverse: false)
        cipherRound.afterShiftRows = result
        
        let lastKey = getRoundKeys[getNrOfRounds].convertToState()
        state.addRoundKey(state: &result, key: lastKey)
        cipherRound.afterAddRound = result
        cipherRound.roundKey = lastKey
        
        cipherHistory.append(cipherRound)
        cipherHistory.append(CipherRound(index: getNrOfRounds + 1, startOfRound: result))
        
    }
    
    /// Performs the decryption process on the current state using the AES algorithm.
    ///
    /// This function executes the AES decryption process step-by-step, using the previously expanded round keys.
    /// It works through the cipher rounds in reverse order, starting from the last round and applying inverse
    /// transformations such as inverse ShiftRows, inverse SubBytes, and inverse MixColumns. After each round,
    /// the round key is applied using the `addRoundKey` operation.
    ///
    /// The history of each round's state, including after each transformation step, is stored in `cipherHistory`
    /// as a series of `CipherRound` objects.
    func decryptState() {
        createKeyExpansion()

        let lastKey = getRoundKeys[getNrOfRounds].convertToState()
        
        var startRound = CipherRound(index: 0, startOfRound: result, roundKey: lastKey)
        
        state.addRoundKey(state: &result, key: lastKey)
        startRound.afterAddRound = result
        
        _ = state.shiftRows(state: &result, isInverse: true)
        startRound.afterShiftRows = result
        
        state.subBytes(state: &result, isInverse: true)
        startRound.afterSubBytes = result
        
        cipherHistory.append(startRound)
        
        var currentIndex = 1
        
        for round in stride(from: getNrOfRounds - 1, to: 0, by: -1) {
            let roundKey = getRoundKeys[round].convertToState()
            
            var cipherRound = CipherRound(index: currentIndex, startOfRound: result, roundKey: roundKey)
            
            state.addRoundKey(state: &result, key: roundKey)
            cipherRound.afterAddRound = result
   
            
            state.mixColumns(state: &result, isInverse: true)
            cipherRound.afterMixColumns = result
            
            _ = state.shiftRows(state: &result, isInverse: true)
            cipherRound.afterShiftRows = result
            
            state.subBytes(state: &result, isInverse: true)
            cipherRound.afterSubBytes = result
            
            cipherHistory.append(cipherRound)
            currentIndex += 1
        }
        
        let startKey = getRoundKeys[0].convertToState()
        var lastRound = CipherRound(index: currentIndex, startOfRound: result, roundKey: startKey)
        state.addRoundKey(state: &result, key: startKey)
        lastRound.afterAddRound = result
        cipherHistory.append(lastRound)
        cipherHistory.append(CipherRound(index: currentIndex + 1, startOfRound: result))
    }
}

