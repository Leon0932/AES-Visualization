//
//  AESState.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 28.07.24.
//

import Foundation

final class AESState {
    static let shared = AESState()
    private let math = AESMath.shared
    
    private init() {}
    
    /// Performs the AES SubBytes operation.
    ///
    /// This function applies the `sBox()` method from the `AESMath` class to each element of the `state` array.
    /// Each value in the `state` is transformed using the AES S-Box.
    /// If the `isInverse` flag is `true`, the inverse S-Box transformation is applied instead.
    ///
    /// - Parameters:
    ///   - state: A 2D array of `Byte` representing the current state of the AES operation. It is modified in place.
    ///   - isInverse: A Boolean flag indicating whether the inverse SubBytes operation should be performed.
    ///     If `true`, the inverse S-Box transformation is applied; otherwise, the standard S-Box transformation is applied.
    func subBytes(state: inout [[Byte]], isInverse: Bool) {
        for row in 0..<state.count {
            for col in 0..<state[row].count {
                state[row][col] = isInverse ? math.invSBox[Int(state[row][col])] : math.sBox[Int(state[row][col])]
            }
        }
    }
    
    /// Cyclic left shift of a row
    ///
    /// This function performs a cyclic left shift on a specified row of the AES state matrix.
    /// The `shift` parameter indicates how many positions the row (`row`) should be shifted.
    ///
    /// - Parameters:
    ///   - state: A 2D array of `Byte` representing the current state of the AES operation. It is modified in place.
    ///   - row: The index of the row in the `state` matrix to be shifted.
    ///   - shift: The number of positions to shift the row.
    /// - Returns: The history of the modified states (up to three states).
    func shiftRow(state: inout [[Byte]], row: Int, shift: Int) -> [[Byte]] {
        guard shift != 0 else { return [] }
        var result: [[Byte]] = [[], [], []]
        
        for shift in 0..<shift {
            let first = state[row].removeFirst()
            state[row].append(first)
            result[shift].append(contentsOf: state[row])
        }
        
        return result
    }
    
    /// Performs the AES ShiftRows operation.
    ///
    /// This function applies a `shiftRow()` operation for each row of the `state` array.
    /// The first row is unaffected by the `shiftRow()` operation.
    ///
    /// - Parameters:
    ///   - state: A 2D array of `Byte` representing the current state of the AES operation. It is modified in place.
    ///   - isInverse: A Boolean flag indicating whether the inverse ShiftRows operation should be performed.
    ///     If `true`, the rows are shifted in the opposite direction; otherwise, the standard ShiftRows operation is applied.
    ///
    /// - Returns: An array of `ShiftRowRound` representing the details of each shift operation performed on the state rows.
    func shiftRows(state: inout [[Byte]], isInverse: Bool) -> [ShiftRowRound] {
        var results: [ShiftRowRound] = []
        results.append(ShiftRowRound(index: 0,
                                     temp: state[0],
                                     shifts: [[], [], []]))
        
        for i in 1..<4 {
            var round: ShiftRowRound = ShiftRowRound(index: i, temp: state[i], shifts: [])
            
            round.shifts.append(contentsOf: shiftRow(state: &state, row: i, shift: isInverse ? 4 - i : i))
            results.append(round)
        }
        
        return results
    }
    
    /// Performs the AES MixColumns operation.
    ///
    /// This function processes the `state` column by column using a given 4x4 matrix.
    /// Each column of the `state` is multiplied by the respective matrix (either normal or inverse depending on `isInverse`).
    /// The calculations are done over GF(2^8) (Galois Field). The following computation is performed for each element,
    /// where `m` is the matrix, `i` is the row of the matrix, and `j` is the column:
    ///
    ///  b' = (m(i, 0) * state(0, j)) + (m(i, 1) * state(1, j)) + (m(i, 2) * state(2, j)) + (m(i, 3) * state(3, j))
    ///
    /// - Parameters:
    ///   - state: A 2D array of `Byte` representing the current state of the AES operation. It is modified in place.
    ///   - isInverse: A Boolean flag indicating whether the inverse MixColumns operation should be performed.
    ///     If `true`, the inverse matrix is used; otherwise, the standard matrix is applied.
    ///
    func mixColumns(state: inout [[Byte]], isInverse: Bool) {
        let matrix: [[Byte]] = isInverse ? AESConstants.invMixColumnMatrix : AESConstants.mixColumnMatrix
        
        var temp: [Byte] = Array(repeating: Byte(0), count: 4)
        
        for col in 0..<4 {
            for row in 0..<4 {
                temp[row] =
                math.mul(a: matrix[row][0], b: state[0][col]) ^
                math.mul(a: matrix[row][1], b: state[1][col]) ^
                math.mul(a: matrix[row][2], b: state[2][col]) ^
                math.mul(a: matrix[row][3], b: state[3][col])
            }
            
            for row in 0..<4 {
                state[row][col] = temp[row]
            }
        }
    }
    
    /// Performs the AES AddRoundKey operation.
    ///
    /// This function adds (XORs) the individual bytes from the `state` array with a round key.
    /// The process is repeated over 4 iterations, where in each iteration a "word" (32 bits)
    /// from the `key` parameter is extracted and XORed with the corresponding byte in the state.
    ///
    /// - Parameters:
    ///   - state: A 2D array of `Byte` representing the current state of the AES operation. It is modified in place.
    ///   - key: A 2D array of `Byte` representing the round key to be XORed with the state.
    func addRoundKey(state: inout [[Byte]], key: [[Byte]]) {
        for row in 0..<4 {
            state[row] = zip(state[row], key[row]).map(^)
        }
    }
}

