//
//  ByteExtension.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 15.10.24.
//

import SwiftUI

extension Byte {
    /// Converts a byte to its binary representation as a string.
    ///
    /// - Returns: A binary string with 8 bits, padded with leading zeros if necessary.
    func toBinary() -> String {
        return String(self, radix: 2).leftPadding(toSize: 8, with: "0")
    }
}
