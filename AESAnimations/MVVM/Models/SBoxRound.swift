//
//  SBoxRound.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 15.10.24.
//

import SwiftUI

struct SBoxRound: Identifiable {
    let id: UUID = UUID()
    let index: Int
    var inv: Byte
    var invBinar: [Int]
    var invFirstShift: [Int]
    var invSecondShift: [Int]
    var invThirdShift: [Int]
    var invFourdShift: [Int]
    var result: Byte
    var resultBinar: [Int]
}
