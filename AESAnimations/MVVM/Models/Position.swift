//
//  Position.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.08.24.
//

import Foundation

/// Represents a coordinate pair (`x`, `y`) used for layout adjustments with
/// SwiftUI ViewModifiers such as `position` and `offset`.
struct Position {
    var x: CGFloat
    var y: CGFloat
}

/// Utility functions for creating arrays of `Position` instances,
/// useful for initializing default layouts or managing positional data.
extension Position {
    static func default2DPositions(rows: Int, cols: Int) -> [[Position]] {
        return Array(repeating: Array(repeating: Position(x: 0, y: 0), count: cols), count: rows)
    }
    
    static func default1DPositions(count: Int) -> [Position] {
        return Array(repeating: Position(x: 0, y: 0), count: count)
    }
}
