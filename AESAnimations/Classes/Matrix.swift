//
//  Matrix.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import Foundation

struct Matrix {
    var rows: Int
    var columns: Int
    var data: [[String]]
    var invalidInputFlags: [[Bool]]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.data = Array(repeating: Array(repeating: "FF", count: columns), count: rows)
        self.invalidInputFlags = Array(repeating: Array(repeating: false, count: columns), count: rows)
    }
    
    var areAllFieldsValid: Bool {
        !invalidInputFlags.flatMap { $0 }.contains(true) && !data.flatMap { $0 }.contains { $0.isEmpty }
    }
    
    var containsInvalidInput: Bool {
        invalidInputFlags.flatMap { $0 }.contains(true)
    }
    
    mutating func validateHexInput(row: Int, column: Int, value: String) {
        let hexSet = CharacterSet(charactersIn: "0123456789ABCDEF")
        let inputSet = CharacterSet(charactersIn: value.uppercased())
        invalidInputFlags[row][column] = !(hexSet.isSuperset(of: inputSet) && !value.isEmpty)
    }
    
    mutating func generateAndFillRandomBytes() {
        if let randomBytes = generateRandomBytes(count: rows * columns) {
            for (i, byte) in randomBytes.enumerated() {
                let row = i / columns
                let column = i % columns
                let hexString = String(format: "%02X", byte)
                data[row][column] = hexString
                validateHexInput(row: row, column: column, value: hexString)
            }
        }
    }
    
    mutating func clearData() {
        data = Array(repeating: Array(repeating: "", count: columns), count: rows)
    }
    
    private func generateRandomBytes(count: Int) -> [Byte]? {
        var bytes = [Byte](repeating: 0, count: count)
        let status = SecRandomCopyBytes(kSecRandomDefault, count, &bytes)
        return status == errSecSuccess ? bytes : nil
    }
    
    func toByteArray() -> [Byte] {
        var byteArray: [Byte] = []

        for column in 0..<columns {
            for row in 0..<rows {
                let hexString = data[row][column]
                if let byte = Byte(hexString, radix: 16) {
                    byteArray.append(byte)
                }
            }
        }
        
        return byteArray
    }
    
}
