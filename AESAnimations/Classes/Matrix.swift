//
//  Matrix.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import Foundation

/// Helper struct to manage and validate data from an input matrix,
/// such as a grid of hexadecimal values.
struct Matrix {
    // MARK: - Properties
    var rows: Int
    var columns: Int
    var data: [[String]]
    var invalidInputFlags: [[Bool]]
    
    
    /// Initializes the matrix with the specified number of rows and columns.
    /// Each cell is initialized with a default value ("00") and marked as valid.
    ///
    /// - Parameters:
    ///   - rows: The number of rows in the matrix.
    ///   - columns: The number of columns in the matrix.
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.data = Array(repeating: Array(repeating: "00", count: columns), count: rows)
        self.invalidInputFlags = Array(repeating: Array(repeating: false, count: columns), count: rows)
    }
    
    // MARK: - Main Functions
    /// Validates if the input value is a valid hexadecimal byte (00 - FF).
    ///
    /// - Parameters:
    ///   - row: The row index of the cell.
    ///   - column: The column index of the cell.
    ///   - value: The input string to validate as a hexadecimal byte.
    mutating func validateHexInput(row: Int, column: Int, value: String) {
        let hexSet = CharacterSet(charactersIn: "0123456789ABCDEF")
        let inputSet = CharacterSet(charactersIn: value.uppercased())
        invalidInputFlags[row][column] = !(hexSet.isSuperset(of: inputSet) && !value.isEmpty)
    }
    
    
    /// Fills the matrix with random hexadecimal bytes and validates each generated byte.
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
    
    // MARK: - Helper Functions
    /// Generates an array of random bytes.
    ///
    /// - Parameter count: The number of random bytes to generate.
    /// - Returns: An array of random bytes, or `nil` if generation fails.
    private func generateRandomBytes(count: Int) -> [Byte]? {
        var bytes = [Byte](repeating: 0, count: count)
        let status = SecRandomCopyBytes(kSecRandomDefault, count, &bytes)
        return status == errSecSuccess ? bytes : nil
    }
    
    /// Indicates whether all fields contain valid and non-empty values.
    var areAllFieldsValid: Bool {
        !invalidInputFlags.flatMap { $0 }.contains(true) && !data.compactMap { $0 }.contains { $0.isEmpty }
    }
    
    /// Indicates if any cell contains invalid input.
    var containsInvalidInput: Bool {
        invalidInputFlags.flatMap { $0 }.contains(true)
    }
    
    /// Checks  if every cell contains 00 input.
    var checkNullBytes: Bool {
        data.flatMap { $0 }.allSatisfy { $0 == "00" }
    }
    
    /// Clears all data in the matrix by setting each cell to an empty string.
    mutating func clearData() {
        data = Array(repeating: Array(repeating: "", count: columns), count: rows)
    }
    
    /// Fills all data in the matrix by setting each cell to a string "00".
    mutating func fillData()  {
        data = Array(repeating: Array(repeating: "00", count: columns), count: rows)
    }
}
