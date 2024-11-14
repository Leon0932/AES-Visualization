//
//  ShiftRowsHelper.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 04.09.24.
//

import Foundation


/// Helper class for `ShiftRowsViewModel` and
/// `KeyExpansionViewModel (RotWordAnimation)`
class ShiftRowsHelper {
    // MARK: - Properties
    let boxSize: CGFloat
    let spacing: CGFloat
    
    let boxSizeWithSpacing: CGFloat
    let middleOffset: CGFloat
    let returnOffset: CGFloat
    
    
    /// Calculates values for the ShiftRows animation:
    ///
    /// - `boxSizeWithSpacing`: Determines the amount to shift boxes to the left or upward.
    /// - `middleOffset`: Moves the box to the center position.
    /// - `returnOffset`: Sets the new offset for the shifted box.
    ///
    /// - Parameters:
    ///   - boxSize: The size of each box (`CellView`).
    ///   - spacing: The spacing between each box.
    init(boxSize: CGFloat, spacing: CGFloat) {
        
        self.boxSize = boxSize
        self.spacing = spacing
        self.boxSizeWithSpacing = boxSize + spacing
        
        self.middleOffset = boxSizeWithSpacing + (boxSizeWithSpacing / 2)
        self.returnOffset = boxSizeWithSpacing * 3
        
    }
}
