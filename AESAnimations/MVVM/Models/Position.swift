//
//  Position.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.08.24.
//

import Foundation

// Eine allgemeine Struktur für Positionen, die in mehreren Klassen verwendet werden kann
struct Position {
    var x: CGFloat
    var y: CGFloat
}

extension Position {
    static func default2DPositions(rows: Int, cols: Int) -> [[Position]] {
        return Array(repeating: Array(repeating: Position(x: 0, y: 0), count: cols), count: rows)
    }
    
    static func default1DPositions(count: Int) -> [Position] {
        return Array(repeating: Position(x: 0, y: 0), count: count)
    }
    
    static func updatePosition(positions: inout [[Position]], row: Int, col: Int, by position: Position) {
        positions[row][col] = position
    }
}
