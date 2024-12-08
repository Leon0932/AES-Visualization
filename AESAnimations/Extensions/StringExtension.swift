//
//  StringExtension.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 15.10.24.
//

import SwiftUI

extension String {
    /// Adds left padding to a string with a specified character.
    ///
    /// This function adds padding to the beginning of the string until it reaches the specified size.
    /// If the string is already equal to or larger than the specified size, it remains unchanged.
    ///
    /// - Parameters:
    ///   - toSize: The desired total length of the string after padding.
    ///   - character: The character to use for padding.
    /// - Returns: A new string with the specified padding applied.
    func leftPadding(toSize: Int, with character: Character) -> String {
        let paddingCount = toSize - self.count
        if paddingCount > 0 {
            return String(repeating: character, count: paddingCount) + self
        } else {
            return self
        }
    }

    /// Converts a string to an array of integers.
    /// Characters that cannot be converted to integers are ignored.
    ///
    /// - Returns: An array of integers representing each character in the string as an integer.
    func toIntArray() -> [Int] {
        self.compactMap { Int(String($0)) }
    }
}
