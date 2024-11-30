//
//  ArrayExtensions.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 15.08.24.
//

import Foundation

extension Array {
    static func create1DArray(repeating element: Element,
                              count: Int) -> [Element] {
        return Array(repeating: element, count: count)
    }
    
    static func create2DArray(repeating element: Element,
                              rows: Int,
                              cols: Int) -> [[Element]] where Element: Any {
        return Array<Array<Element>>(repeating: Array<Element>(repeating: element, count: cols), count: rows)
    }
}


extension Array where Element == [Byte] {
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
    /// Converts the matrix data to an array of bytes.
    ///
    /// - Returns: An array of bytes, with each cell's hex value converted to a byte.
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
    
    func hexStringTo2DByteArray() -> [[Byte]] {
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
    func shiftRow(by shift: Int) -> [Int] {
        var result = self
        
        for _ in 0..<shift {
            result.removeLast()
            result.insert(0, at: 0)
        }
        
        return result
    }
}
