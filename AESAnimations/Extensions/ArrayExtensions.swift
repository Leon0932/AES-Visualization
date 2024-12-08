//
//  ArrayExtensions.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 15.08.24.
//

import Foundation

extension Array {
    /// Creates a one-dimensional array with a specified element and size.
    ///
    /// This function generates a one-dimensional array where all elements are the same,
    /// based on the provided element and the desired size.
    ///
    /// - Parameters:
    ///   - element: The element to populate the array with.
    ///   - count: The number of elements in the array.
    /// - Returns: A one-dimensional array containing the specified element repeated `count` times.
    static func create1DArray(repeating element: Element,
                              count: Int) -> [Element] {
        return Array(repeating: element, count: count)
    }
    
    /// Creates a two-dimensional array with a specified element and dimensions.
    ///
    /// This function generates a two-dimensional array where all elements are the same,
    /// based on the provided element and the specified number of rows and columns.
    ///
    /// - Parameters:
    ///   - element: The element to populate the array with.
    ///   - rows: The number of rows in the array.
    ///   - cols: The number of columns in the array.
    /// - Returns: A two-dimensional array containing the specified element repeated for the given dimensions.
    static func create2DArray(repeating element: Element,
                              rows: Int,
                              cols: Int) -> [[Element]] where Element: Any {
        return Array<Array<Element>>(repeating: Array<Element>(repeating: element, count: cols), count: rows)
    }
}


extension Array where Element == [Byte] {
    /// Splits a 2D array into smaller chunks and returns them as a new 2D array.
    ///
    /// This function takes a two-dimensional array and divides its inner arrays into smaller chunks of the specified size.
    /// The resulting chunks are returned as a two-dimensional array.
    ///
    /// - Parameter chunkSize: The size of each chunk to be created from the inner arrays.
    /// - Returns: A two-dimensional array containing the smaller chunks.
    func split2DArrayIntoChunks(chunkSize: Int) -> [[Element.Element]] {
        var result: [[Element.Element]] = []
        
        for innerArray in self {
            var i = 0
            while i < innerArray.count {
                let endIndex = Swift.min(i + chunkSize, innerArray.count)
                let chunk = Array<Element.Element>(innerArray[i..<endIndex])
                result.append(chunk)
                i += chunkSize
            }
        }
        
        return result
    }
    
    /// Converts a 2D array into a 1D array.
    ///
    /// This function flattens a two-dimensional array into a one-dimensional array by concatenating all the elements in row-major order.
    ///
    /// - Returns: A one-dimensional array containing all the elements of the 2D array.
    func convertTo1DArray() -> [Byte] {
        guard !self.isEmpty else { return [] }
        
        var result = [Byte]()
        
        let columnCount = self[0].count
        for col in 0..<columnCount {
            for row in 0..<self.count {
                result.append(self[row][col])
            }
        }
        
        return result
    }
}

extension Array where Element == Byte {
    /// Converts a one-dimensional array into a 2D AES State Matrix.
    ///
    /// This function takes a one-dimensional array of bytes and converts it into a two-dimensional matrix
    /// structured as an AES State Matrix. The resulting matrix has 4 rows and `count / 4` columns.
    ///
    /// - Returns: A 2D array (`AES State Matrix`)
    func convertToState() -> [[Byte]] {
        let count = self.count / 4
        
        var result = [[Byte]](repeating: [Byte](repeating: 0, count: count), count: 4)
        
        for (index, value) in self.enumerated() {
            let col = index / 4
            let row = index % 4
            result[row][col] = value
        }
        
        return result
    }
}

extension Array where Element == [String] {
    /// Converts the matrix data into an array of bytes.
    ///
    /// This function flattens a 2D array, interpreting each cell's value as a hexadecimal string
    /// and converting it to a byte. The conversion follows in column order.
    ///
    /// - Returns: An array of bytes, derived from the hexadecimal values in the matrix.
    func toByteArray() -> [Byte] {
        guard !self.isEmpty else { return [] }
        
        var result: [Byte] = []
        
        for column in 0..<self[0].count {
            for row in 0..<self.count {
                let hexString = self[row][column]
                if let byte = Byte(hexString, radix: 16) {
                    result.append(byte)
                }
            }
        }
        
        return result
    }
    
    /// Converts the matrix data into a 2D array of bytes.
    ///
    /// This function flattens a 2D array of hexadecimal string values, interpreting each cell's value
    /// as a hexadecimal string and converting it to a byte. The conversion follows in row order
    ///
    /// - Returns: A 2D array of bytes derived from the hexadecimal string values in the matrix.
    func to2DByteArray() -> [[Byte]] {
        var byteArray: [[Byte]] = []
        
        for row in self {
            var byteRow: [Byte] = []
            for hexString in row {
                if let byte = Byte(hexString, radix: 16) {
                    byteRow.append(byte)
                }
            }
            byteArray.append(byteRow)
        }
        
        return byteArray
    }
}

extension Array where Element == Int {
    /// Performs a row shift on an integer array.
    ///
    /// This function shifts the elements of the array to the left by the specified amount,
    /// wrapping the removed elements back to the beginning of the array.
    ///
    /// - Parameter shift: The number of positions to shift the elements.
    /// - Returns: A new array with the elements shifted by the specified amount.
    func shiftRow(by shift: Int) -> [Int] {
        var result = self
        
        for _ in 0..<shift {
            result.removeLast()
            result.insert(0, at: 0)
        }
        
        return result
    }
}
