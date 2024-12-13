//
//  OperationDetails.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 13.09.24.
//

import SwiftUI

/// A data structure for storing information about the current animation operation,
/// including its state and associated parameters.
struct OperationDetails {
    var operationName: OperationNames
    var isInverseMode: Bool
    var currentRound: Int
}
