//
//  AESKeySchedule.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 28.07.24.
//

import Foundation

class AESKeySchedule {
    // MARK: - Properties
    let math = AESMath.shared
    private var keySchedule: [[Byte]] = []
    private var roundKeys: [[Byte]] = []
    private var keyExpRounds: [KeyExpansionRound] = []
    
    private var keySize: AESKeySize? = nil
    private var nk: Int = 0
    private var nr: Int = 0
    private let nb: Int = 4
    private var rCon: [[Byte]]
    
    // MARK: - Initializer
    init() {
        rCon = AESConstants.rcon
    }
    
    // MARK: - Computed Properites
    /// Returns the number of rounds in the encryption process.
    ///
    /// This computed property provides the total number of rounds used during
    /// the encryption or decryption process, based on the key size.
    ///
    /// - Returns: An integer representing the number of rounds.
    var getNrOfRounds: Int { return nr }
    
    /// Returns the size of the key in words.
    ///
    /// This computed property provides the number of words
    /// in the key based on its size.
    ///
    /// - Returns: An integer representing the key size in words.
    var getNk: Int { return nk }
    
    /// Returns the AES key size based on the current key value.
    ///
    /// This computed property checks if the key size corresponds to one of the
    /// predefined AES key sizes (128, 192, or 256 bits) and returns the appropriate
    /// `AESKeySize` enum. If the key size is invalid, it returns `nil`.
    ///
    /// - Returns: An optional `AESKeySize` enum representing the key size, or `nil` if the key size is invalid.
    var getKeySize: AESKeySize? {
        if let keySize = AESKeySize(rawValue: nk) {
            return keySize
        }
        
        return nil
    }
    
    /// Returns the round keys generated during the key expansion process.
    ///
    /// This computed property provides the complete set of round keys that were derived
    /// from the initial key through the key expansion process. Each round key
    /// is represented as an array of bytes.
    ///
    /// - Returns: A 2D array of `Byte` objects, where each inner array represents
    ///            a round key from the key expansion process.
    var getRoundKeys: [[Byte]] { roundKeys }
    
    /// Returns the detailed history of the key expansion rounds.
    ///
    /// This computed property provides a list of all key expansion rounds that were generated
    /// during the key scheduling process.
    ///
    /// - Returns: An array of `KeyExpansionRound` objects representing the detailed
    ///            history of each round in the key expansion process.
    var getDetailedKeySchedule: [KeyExpansionRound] { keyExpRounds }
    
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
    /// - Returns: An array of bytes where the first byte has been moved to the end.
    func rotWord(_ w: [Byte]) -> [Byte] {
        var result = w
        
        let first = result.removeFirst()
        result.append(first)
        
        return result
    }
    
    /// Applies the S-Box transformation to a word (array of bytes).
    ///
    /// This function performs the S-Box transformation on each byte
    /// of the input word.
    ///
    /// - Parameter w: An array of bytes representing the input word.
    /// - Returns: An array of bytes where each byte has been substituted using the S-Box.
    func subWord(_ w: [Byte]) -> [Byte] {  return w.map { math.sBox($0) } }
    
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
    func keyExpansion(key: [Byte]) {
        roundKeys = []
        keySchedule = []
        keyExpRounds = []
        
        keySize = AESKeySize(rawValue: key.count * 8 / 32)
        
        guard let keySize else { return }
        
        nk = keySize.rawValue
        nr = keySize.rounds
        
        for i in stride(from: 0, to: nk * 4, by: 4) {
            let block = Array(key[i..<i+4])
            keySchedule.append(block)
        }
        
        let range = nb * (nr + 1)
        for index in nk..<range {
            var temp: [Byte] = keySchedule[index - 1]
            
            var keyRound = KeyExpansionRound(index: index, temp: temp)
            
            if index % keySize.rawValue == 0 {
                let tempRotWord = rotWord(temp)
                let tempSubWord = subWord(tempRotWord)
                let rConstant = rCon[index / keySize.rawValue]
                for i in 0..<nb {
                    temp[i] = tempSubWord[i] ^ rConstant[i]
                }
                
                
                keyRound.afterRotWord = tempRotWord
                keyRound.afterSubWord = tempSubWord
                keyRound.rcon = rConstant
                keyRound.afterXORWithRCON = temp
                
            } else if keySize == .key256 && index % keySize.rawValue == 4 {
                temp = subWord(temp)
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
