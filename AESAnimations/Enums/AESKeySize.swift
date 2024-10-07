//
//  AESKeySize.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 30.07.24.
//

import Foundation

enum AESKeySize: Int {
    case key128 = 4
    case key192 = 6
    case key256 = 8 
    
    var rounds: Int {
        switch self {
        case .key128: return 10
        case .key192: return 12
        case .key256: return 14
        }
    }
}
