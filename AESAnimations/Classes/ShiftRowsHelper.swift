//
//  ShiftRowsHelper.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 04.09.24.
//

import Foundation

class ShiftRowsHelper {
    let boxSize: CGFloat
    let spacing: CGFloat
    
    let boxSizeWithSpacing: CGFloat
    let middleOffset: CGFloat
    let returnOffset: CGFloat
    
    init(boxSize: CGFloat, spacing: CGFloat) {
        
        self.boxSize = boxSize
        self.spacing = spacing
        self.boxSizeWithSpacing = boxSize + spacing
        
        self.middleOffset = boxSizeWithSpacing + (boxSizeWithSpacing / 2)
        self.returnOffset = boxSizeWithSpacing * 3
        
    }
}
