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
        // Berechne die Anzahl der Spalten (oder besser gesagt, die Anzahl der "Wörter")
        let count = self.count / 4  // Dies ist die Anzahl der Spalten für AES (in 4 Byte Blöcken)
        
        // Initialisiere die Matrix mit der richtigen Größe (4 Zeilen und entsprechende Anzahl an Spalten)
        var result = [[Byte]](repeating: [Byte](repeating: 0, count: count), count: 4)
        
        // Fülle die Matrix spaltenweise mit den Werten aus dem Byte-Array
        for (index, value) in self.enumerated() {
            let col = index / 4  // Spalte wird durch die Anzahl der Zeilen (4) definiert
            let row = index % 4  // Zeile wird durch den Modulo 4 berechnet
            result[row][col] = value
        }
        
        return result
    }
}
