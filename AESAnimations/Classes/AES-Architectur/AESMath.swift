//
//  AESMath.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 28.07.24.
//

import Foundation

class AESMath {
    static let shared = AESMath()
    
    private var logTable: [Byte]
    private var expTable: [Byte]
    private var sBox: [Byte]
    private var invSBox: [Byte]
    
    private init() {
        expTable = [Byte](repeating: 0, count: 256)
        logTable = [Byte](repeating: 0, count: 256)
        sBox = [Byte](repeating: 0, count: 256)
        invSBox = [Byte](repeating: 0, count: 256)
        
        initializeTables()
    }
    
    /// Initializes the following tables:
    /// - Exponentiation table
    /// - Logarithm table
    /// - S-Box and inverse S-Box tables
    private func initializeTables() {
        var value: Byte = 1
        
        // Initialize the exponentiation and logarithm tables
        for i in 0..<255 {
            expTable[i] = value
            logTable[Int(value)] = Byte(i)
            value = rpmul(a: value, b: AESConstants.generator)
        }
        // The last value in the exponentiation table
        // is always 1
        expTable[255] = 1
        // The first value in the logarithm table
        // is always 0xFF
        logTable[1] = 0xFF
        
        // Initialize the S-Box and inverse S-Box tables
        for i in 0..<256 {
            let x: Byte = inv(b: Byte(i))
            let y: Byte = aTrans(x: x)
            
            sBox[i] = y
            invSBox[Int(y)] = Byte(i)
        }
    }
    
    /// Exponential function in GF(256)
    ///
    /// This function returns the exponential value of a byte `i` in the Galois Field GF(256)
    /// using the `expTable`.
    ///
    /// - Parameter i: The input value as a byte
    /// - Returns: The exponential value of the input in GF(256)
    func exp(_ i: Byte) -> Byte { return expTable[Int(i)] }
    
    /// Logarithm function in GF(256)
    ///
    /// This function returns the logarithm of a byte `b` in the Galois Field GF(256)
    /// using the `logTable`.
    ///
    /// - Parameter b: The input value as a byte
    /// - Returns: The logarithm of the input value in GF(256)
    func log(_ b: Byte) -> Byte { return logTable[Int(b)] }
    
    /// S-Box lookup in GF(256)
    ///
    /// This function returns the transformed byte from the `sBox` table.
    ///
    /// - Parameter b: The byte to be transformed
    /// - Returns: The transformed byte from the S-Box
    func sBox(_ b: Byte) -> Byte { return sBox[Int(b)] }
    
    /// Inverse S-Box lookup in GF(256)
    ///
    /// This function returns the transformed byte from the `invSbox` table.
    ///
    /// - Parameter b: The byte to be transformed
    /// - Returns: The transformed byte from the inverse S-Box
    func invSBox(_ b: Byte) -> Byte { return invSBox[Int(b)] }
    
    /// Addition of two bytes in GF(256)
    ///
    /// This function computes the addition of two bytes (`a` and `b`) in the Galois Field GF(256)
    /// using the XOR operation and returns the result.
    ///
    /// - Parameters:
    ///   - a: The first byte
    ///   - b: The second byte
    /// - Returns: The result of the addition of the two bytes
    func add(a: Byte, b: Byte) -> Byte { return a ^ b }
    
    /// Doubling a byte in GF(256)
    ///
    /// This function doubles a byte `b` in the Galois Field GF(256).
    /// The byte is shifted to the left. If the highest bit of `b` is set,
    /// the result is XORed with the irreducible polynomial `0x1b`.
    ///
    /// - Parameter b: The byte to be doubled
    /// - Returns: The result of doubling the byte in GF(256)
    func xtime(b: Byte) -> Byte {
        var r: Byte = b << 1
        if (b & 0x80) != 0 {
            r ^= AESConstants.irreduciblePolynomial
        }
        return r
    }
    
    /// Russian peasant multiplication in GF(256)
    ///
    /// This function multiplies the bytes `a` and `b` in the Galois Field GF(256)
    /// using the Russian peasant multiplication method and returns the result. While `a` is greater
    /// than zero, it is added to an initial byte `p` (if `a` is odd). Then, `a` is halved
    /// and `b` is doubled using the `xtime(b)` method.
    ///
    /// - Parameters:
    ///   - a: The first byte
    ///   - b: The second byte
    /// - Returns: The result of multiplying the two bytes in GF(256)
    func rpmul(a: Byte, b: Byte) -> Byte {
        if a == 0 || b == 0 {
            return 0
        }
        var aTemp = a
        var bTemp = b
        var p: Byte = 0
        while aTemp > 0 {
            if aTemp & 1 == 1 {
                p = add(a: p, b: bTemp)
            }
            aTemp >>= 1
            bTemp = xtime(b: bTemp)
        }
        return p
    }
    
    /// Multiplication of two bytes in GF(256)
    ///
    /// This function multiplies the bytes `a` and `b` in the Galois Field GF(256)
    /// using the `logTable` and `expTable`. The logarithms of both bytes are looked up
    /// in the `logTable` and added, with the result taken modulo 255. The result of this
    /// calculation is then used to look up the product in the `expTable` and return the result.
    ///
    /// - Parameters:
    ///   - a: The first byte
    ///   - b: The second byte
    /// - Returns: The result of multiplying the two bytes in GF(256)
    func mul(a: Byte, b: Byte) -> Byte {
        if a == 0 || b == 0 {
            return 0
        }
        let i: Byte = log(a)
        let j: Byte = log(b)
        let sum = Int(i) + Int(j)
        let l = sum % 255
        
        return exp(Byte(l))
    }
    
    /// Inversion of a byte in GF(256)
    ///
    /// This function inverts a byte `b` in the Galois Field GF(256) using the `logTable`
    /// and `expTable`, and returns the result. The logarithmic value of `b` is found,
    /// subtracted from 255, and then the corresponding exponential value is determined.
    ///
    /// - Parameter b: The byte to be inverted
    /// - Returns: The inverse of the byte in GF(256)
    func inv(b: Byte) -> Byte {
        if b == 0 {
            return 0
        }
        
        let i: Byte = log(b)
        let l: Byte = 255 - i
        
        return exp(l)
    }
    
    /// Determining the parity of a byte in GF(256)
    ///
    /// This function calculates whether the number of ones in the binary representation of `b`
    /// is odd or even.
    ///
    /// - Parameter b: The byte to be checked
    /// - Returns: 1 if the number of ones is odd, 0 if the number of ones is even
    func parity(b: Byte) -> Byte {
        var cntr: Byte = 0
        var bTemp = b
        
        while bTemp != 0 {
            cntr = add(a: cntr, b: bTemp & 1)
            bTemp >>= 1
        }
        
        return cntr % 2
    }
    
    /// Calculation of the linear / affine transformation
    ///
    /// This function calculates the linear / affine transformation for a byte `x`
    /// and returns the result. Each bit is computed as follows (where + stands for XOR):
    ///
    /// 1. bi + b(i+4) mod 8 + b(i+5) mod 8 + b(i+6) mod 8 + b(i+7) mod 8 + ci
    /// 2. The parity of the result of bi is set in a new byte `result`
    /// using the function `parity()`.
    /// 3. Finally, the result is returned.
    ///
    /// The value `ci` is the i-th bit of the byte 0x63.
    ///
    /// - Parameter x: The byte to be transformed
    /// - Returns: The byte after the affine transformation
    func aTrans(x: Byte) -> Byte {
        var result: Byte = 0
        let c = AESConstants.affineConstant
        
        for i in 0..<8 {
            let bI = ((x >> i) & 1)
                ^ ((x >> ((i + 4) % 8)) & 1)
                ^ ((x >> ((i + 5) % 8)) & 1)
                ^ ((x >> ((i + 6) % 8)) & 1)
                ^ ((x >> ((i + 7) % 8)) & 1)
                ^ ((c >> i) & 1)
            
            let parityBit = parity(b: bI)
            result |= parityBit << i
        }
        
        return result
    }
}

