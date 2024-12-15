//
//  AESKeySchedule.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 28.07.24.
//

import Foundation

final class AESKeySchedule {
    // MARK: - Properties
    private let math = AESMath.shared
    private(set) var keySchedule: [[Byte]] = []
    private(set) var roundKeys: [[Byte]] = []
    private(set) var keyExpRounds: [KeyExpansionRound] = []
    
    private(set) var keySize: AESConfiguration? = nil
    private(set) var nk: Int = 0
    private(set) var nr: Int = 0
    private let nb: Int = 4
    private var rCon: [[Byte]]
    
    // MARK: - Initializer
    init() {
        rCon = AESConstants.rcon
    }
    
    // MARK: - Helper functions
    /// Retrieves the round key for a specific round in the key expansion process.
    ///
    /// This function extracts and returns the round key for the specified round.
    /// The round key is formed by combining four rows from the key schedule.
    ///
    /// - Parameter round: The index of the round for which the round key is to be retrieved.
    /// - Returns: An array of `Byte` objects representing the round key for the specified round.
    private func getRoundKey(round: Int) -> [Byte] {
        let startIndex = 4 * round
        let endIndex = startIndex + 4
        
        // Initialisiere eine leere Liste von Bytes
        var roundKey: [Byte] = []
        
        // Füge die 4 Reihen aus dem 2D-Array zu einem eindimensionalen Array zusammen
        for i in startIndex..<endIndex {
            roundKey.append(contentsOf: keySchedule[i])
        }
        
        return roundKey
    }
    
    // MARK: - Main functions
    /// Rotates the input word (array of bytes) by moving the first byte to the end.
    ///
    /// This function shifts all bytes in the input array one position to the left,
    /// with the first byte wrapping around to the end of the array.
    ///
    /// - Parameter w: An array of bytes representing the input word.
    func rotWord(_ w: inout [Byte]) {
        let first = w.removeFirst()
        w.append(first)
    }
    
    /// Applies the S-Box transformation to a word (array of bytes).
    ///
    /// This function performs the S-Box transformation on each byte
    /// of the input word.
    ///
    /// - Parameter w: An array of bytes representing the input word.
    func subWord(_ w: inout [Byte]) {  w = w.map { math.sBox($0) } }
    
    /// Sets the encryption key and generates the round keys.
    ///
    /// This function initializes the encryption key and generates the round keys
    /// required for the AES encryption process. The number of rounds and the size
    /// of the initial key depend on the key size provided:
    ///
    /// - 128-bit key: 10 rounds
    /// - 192-bit key: 12 rounds
    /// - 256-bit key: 14 rounds
    ///
    ///
    /// - Parameter key: A byte array representing the original encryption key. Its
    ///   size must be 16 bytes (128 bits), 24 bytes (192 bits), or 32 bytes (256 bits).
    func keyExpansion(key: [[Byte]]) {
        roundKeys = []
        keySchedule = []
        keyExpRounds = []
        
        keySize = AESConfiguration(rawValue: key[0].count)
        
        guard let keySize else { return }
        
        nk = keySize.rawValue
        nr = keySize.rounds
        
        for i in 0..<nk {
            var word: [Byte] = []
            for j in 0..<4 {
                word.append(key[j][i])
            }
            
            keySchedule.append(word)
        }
        
        let range = nb * (nr + 1)
        for index in nk..<range {
            var temp: [Byte] = keySchedule[index - 1]
            
            var keyRound = KeyExpansionRound(index: index, temp: temp)
            
            if index % keySize.rawValue == 0 {
                rotWord(&temp)
                keyRound.afterRotWord = temp
                subWord(&temp)
                keyRound.afterSubWord = temp
                
                let rConstant = rCon[index / keySize.rawValue]
                for i in 0..<nb {
                    temp[i] ^= rConstant[i]
                }

                keyRound.rcon = rConstant
                keyRound.afterXORWithRCON = temp
                
            } else if keySize == .key256 && index % keySize.rawValue == 4 {
                subWord(&temp)
                keyRound.afterSubWord = temp
            }
            
            let tempKeySched = keySchedule[index - keySize.rawValue]
            var w = temp
            
            for i in 0..<nb {
                w[i] = tempKeySched[i] ^ temp[i]
            }
            
            keyRound.wIMinusNK = tempKeySched
            keyRound.result = w
            
            keySchedule.append(w)
            keyExpRounds.append(keyRound)
            
        }
        
        for round in 0..<nr + 1 { roundKeys.append(getRoundKey(round: round)) }
    }
}
