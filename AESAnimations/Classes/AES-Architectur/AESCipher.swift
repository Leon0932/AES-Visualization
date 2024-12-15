//
//  AESCipher.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 28.07.24.
//

import Foundation

final class AESCipher {
    // MARK: - Properties
    private let keySchedule = AESKeySchedule()
    private let state = AESState.shared
    
    private(set) var input: [[Byte]] = []
    private(set) var key: [[Byte]] = []
    private(set) var result: [[Byte]] = []
    private(set) var cipherHistory: [CipherRound] = []
    
    // MARK: - Initializer
    init(input: [[Byte]], key: [[Byte]]) {
        self.input = input
        self.key = key
    }
    
    // MARK: - Computed Properties From `AESKeySchedule`
    var getRoundKeys: [[Byte]] { keySchedule.roundKeys }
    var getDetailedKeySchedule: [KeyExpansionRound] { keySchedule.keyExpRounds }
    var getKeySize: AESConfiguration { keySchedule.keySize }
    
    // MARK: - Helper functions
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
        print(getKeySize.rawValue)
        let startKey = getRoundKeys[0].convertToState()
        
        var startRound = CipherRound(index: 0, startOfRound: result, roundKey: startKey)
        state.addRoundKey(state: &result, key: startKey)
        startRound.afterAddRound = result
        
        cipherHistory.append(startRound)
        
        let rounds = getKeySize.rounds
        
        for round in 1..<rounds {
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
        
        var cipherRound = CipherRound(index: rounds, startOfRound: result)
        
        state.subBytes(state: &result, isInverse: false)
        cipherRound.afterSubBytes = result
        
        _ = state.shiftRows(state: &result, isInverse: false)
        cipherRound.afterShiftRows = result
        
        let lastKey = getRoundKeys[rounds].convertToState()
        state.addRoundKey(state: &result, key: lastKey)
        cipherRound.afterAddRound = result
        cipherRound.roundKey = lastKey
        
        cipherHistory.append(cipherRound)
        cipherHistory.append(CipherRound(index: rounds + 1, startOfRound: result))
        
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
        let rounds = getKeySize.rounds

        let lastKey = getRoundKeys[rounds].convertToState()
        
        var startRound = CipherRound(index: 0, startOfRound: result, roundKey: lastKey)
        
        state.addRoundKey(state: &result, key: lastKey)
        startRound.afterAddRound = result
        
        _ = state.shiftRows(state: &result, isInverse: true)
        startRound.afterShiftRows = result
        
        state.subBytes(state: &result, isInverse: true)
        startRound.afterSubBytes = result
        
        cipherHistory.append(startRound)
        
        var currentIndex = 1
        
        for round in stride(from: rounds - 1, to: 0, by: -1) {
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

