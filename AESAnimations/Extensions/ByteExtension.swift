//
//  ByteExtension.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 15.10.24.
//

import SwiftUI

extension Byte {
    func toBinary() -> String {
        return String(self, radix: 2).leftPadding(toSize: 8, with: "0")
    }
}
