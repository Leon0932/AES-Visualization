//
//  StringExtension.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 15.10.24.
//

import SwiftUI

extension String {
    func leftPadding(toSize: Int, with character: Character) -> String {
           let paddingCount = toSize - self.count
           if paddingCount > 0 {
               return String(repeating: character, count: paddingCount) + self
           } else {
               return self
           }
       }
    
    func toIntArray() -> [Int] {
        self.compactMap { Int(String($0)) }
    }
}
