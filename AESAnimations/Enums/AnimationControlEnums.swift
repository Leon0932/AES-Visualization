//
//  Speed.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 05.12.24.
//

import SwiftUI

/// Controller for Animation Control, managing the speed and direction settings.
extension AnimationControl {
    enum Speed {
        case normal
        case double
        case triple
    }
    
    enum Direction {
        case forward
        case backward
        case normal
    }
}
