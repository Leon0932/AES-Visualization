//
//  SBoxRound.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 15.10.24.
//

import SwiftUI

/// A data structure for storing information about a single round
/// in the S-Box creation process of AES.
struct SBoxRound: Identifiable, Equatable {
    let id: UUID = UUID()
    let index: Int
    var multInv: Byte
    var multInvBinar: [Int]
    var firstShift: [Int]
    var secondShift: [Int]
    var thirdShift: [Int]
    var fourthShift: [Int]
    var result: Byte
    var resultBinar: [Int]
    
    static func == (lhs: SBoxRound, rhs: SBoxRound) -> Bool {
        return lhs.index == rhs.index &&
        lhs.multInv == rhs.multInv &&
        lhs.multInvBinar == rhs.multInvBinar &&
        lhs.firstShift == rhs.firstShift &&
        lhs.secondShift == rhs.secondShift &&
        lhs.thirdShift == rhs.thirdShift &&
        lhs.fourthShift == rhs.fourthShift &&
        lhs.result == rhs.result &&
        lhs.resultBinar == rhs.resultBinar
    }
}
