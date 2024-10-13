//
//  AESCipher.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 28.07.24.
//

import Foundation

class AESCipher {
    let keySchedule: AESKeySchedule
    let state: AESState
    
    private var input: [Byte] = []
    private var key: [Byte] = []
    private var result: [[Byte]] = []
    private var cipherHistory: [CipherRound] = []
    
    init(keySchedule: AESKeySchedule, state: AESState) {
        self.keySchedule = keySchedule
        self.state = state
    }
    
    var nrOfRounds: Int { keySchedule.getNrOfRounds() }
    var roundKeys: [[Byte]] { keySchedule.getRoundKeys() }
    var keySize: Int { keySchedule.getNk() }
    var getCipherHistory: [CipherRound] { cipherHistory }
    
    func set(input: [Byte], key: [Byte]) {
        self.input = input
        self.key = key
    }
    
    func getResult() -> [[Byte]] {
        return result
    }
    
    func getInput() -> [Byte] {
        return input
    }
    
    func getKey() -> [Byte] {
        return key
    }
    
    private func createKeyExpansion() {
        result = []
        cipherHistory = []
        
        keySchedule.keyExpansion(key: key)
        
        result = input.convertToState()
    }
    
    func encryptState() {
        createKeyExpansion()
        
        let startKey = roundKeys[0].convertToState()
        
        var startRound = CipherRound(index: 0, startOfRound: result, roundKey: startKey)
        state.addRoundKey(state: &result, key: startKey)
        startRound.afterAddRound = result
        
        cipherHistory.append(startRound)
        
        for round in 1..<nrOfRounds {
            var cipherRound = CipherRound(index: round, startOfRound: result)
            
            state.subBytes(state: &result, isInverse: false)
            
            cipherRound.afterSubBytes = result
            
            _ = state.shiftRows(state: &result, isInverse: false)
            
            cipherRound.afterShiftRows = result
            
            state.mixColumns(state: &result, isInverse: false)
            
            cipherRound.afterMixColumns = result
            
            let roundKey = roundKeys[round].convertToState()
            
            state.addRoundKey(state: &result, key: roundKey)
            
            cipherRound.afterAddRound = result
            
            cipherRound.roundKey = roundKey
            
            cipherHistory.append(cipherRound)
        }
        
        var cipherRound = CipherRound(index: nrOfRounds, startOfRound: result)
        
        state.subBytes(state: &result, isInverse: false)
        cipherRound.afterSubBytes = result
        
        _ = state.shiftRows(state: &result, isInverse: false)
        cipherRound.afterShiftRows = result
        
        let lastKey = roundKeys[nrOfRounds].convertToState()
        state.addRoundKey(state: &result, key: lastKey)
        cipherRound.afterAddRound = result
        cipherRound.roundKey = lastKey
        
        cipherHistory.append(cipherRound)
        cipherHistory.append(CipherRound(index: nrOfRounds + 1, startOfRound: result))
        
    }
    
    func decryptState() {
        createKeyExpansion()

        let lastKey = roundKeys[nrOfRounds].convertToState()
        
        var startRound = CipherRound(index: 0, startOfRound: result, roundKey: lastKey)
        
        state.addRoundKey(state: &result, key: lastKey)
        startRound.afterAddRound = result
        
        _ = state.shiftRows(state: &result, isInverse: true)
        startRound.afterShiftRows = result
        
        state.subBytes(state: &result, isInverse: true)
        startRound.afterSubBytes = result
        
        cipherHistory.append(startRound)
        
        var currentIndex = 1
        
        for round in stride(from: nrOfRounds - 1, to: 0, by: -1) {
            let roundKey = roundKeys[round].convertToState()
            
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
        
        let startKey = roundKeys[0].convertToState()
        var lastRound = CipherRound(index: currentIndex, startOfRound: result, roundKey: startKey)
        state.addRoundKey(state: &result, key: startKey)
        lastRound.afterAddRound = result
        cipherHistory.append(lastRound)
        cipherHistory.append(CipherRound(index: currentIndex + 1, startOfRound: result))
        
        
    }
}

