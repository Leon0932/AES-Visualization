//
//  ArrayExtensions.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 15.08.24.
//

import Foundation

extension Array {
    static func create1DArray(repeating element: Element, count: Int) -> [Element] {
        return Array(repeating: element, count: count)
    }
    
    // Funktion zur Erstellung eines zweidimensionalen Arrays
    static func create2DArray(repeating element: Element, rows: Int, cols: Int) -> [[Element]] where Element: Any {
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
