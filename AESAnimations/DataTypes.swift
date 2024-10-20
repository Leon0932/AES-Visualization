//
//  DataTypes.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 28.07.24.
//

import Foundation
import SwiftUI

typealias Byte = UInt8

#if os(iOS)
typealias PlatformColor = UIColor
#elseif os(macOS)
typealias PlatformColor = NSColor
#endif
