//
//  TestView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 15.08.24.
//

import SwiftUI

struct TestView: View {
    let math = AESMath()
    
    @State private var currentState: [[Byte]] = [
        [0x05, 0xC9, 0x1A, 0x13],
        [0x48, 0x29, 0x1F, 0xEA],
        [0x34, 0x6E, 0x6F, 0x0F],
        [0x10, 0x04, 0x3E, 0x99]
    ]
    @State private var miniState: [[Byte]] = [
        [0x05],
        [0x48],
        [0x34],
        [0x10]
    ]
    @State private var key: [[Byte]] = [
        [0x91, 0xBE, 0x9C, 0x81],
        [0x96, 0x57, 0x84, 0x40],
        [0x02, 0xB1, 0xE4, 0x05],
        [0xAA, 0xEE, 0x43, 0xF0]
    ]
    
    let key128Bit: [Byte] = [
        0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6,
        0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c]
    @State private var roundKeys128Bit: [[Byte]] = []
    @State private var roundKeysHistory128Bit: [KeyExpansionRound] = []
    
    let key192Bit: [Byte]  = [
        0x8e, 0x73, 0xb0, 0xf7, 0xda, 0x0e, 0x64, 0x52,
        0xc8, 0x10, 0xf3, 0x2b, 0x80, 0x90, 0x79, 0xe5,
        0x62, 0xf8, 0xea, 0xd2, 0x52, 0x2c, 0x6b, 0x7b
    ]
    @State private var roundKeys192Bit: [[Byte]] = []
    @State private var roundKeysHistory192Bit: [KeyExpansionRound] = []
    
    let key256Bit: [Byte]  = [
        0x60, 0x3d, 0xeb, 0x10, 0x15, 0xca, 0x71, 0xbe,
        0x2b, 0x73, 0xae, 0xf0, 0x85, 0x7d, 0x77, 0x81,
        0x1f, 0x35, 0x2c, 0x07, 0x3b, 0x61, 0x08, 0xd7,
        0x2d, 0x98, 0x10, 0xa3, 0x09, 0x14, 0xdf, 0xf4
    ]
    @State private var roundKeys256Bit: [[Byte]] = []
    @State private var roundKeysHistory256Bit: [KeyExpansionRound] = []
    
    @State private var resultSubBytes: [[Byte]] = []
    @State private var resultShiftRows: [[Byte]] = []
    @State private var resultMixColumns: [[Byte]] = []
    @State private var resultAddRoundKey: [[Byte]] = []
    
    @State var shiftRowsRound: [ShiftRowRound] = []
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    
                    SubBytesAnimationView(viewModel:
                                            SubBytesViewModel(state: currentState,
                                                              result: resultSubBytes,
                                                              operationDetails: OperationDetails(operationName: .subBytes,
                                                                                                 isInverseMode: false,
                                                                                                 currentRound: 7)))
                    
                } label: {
                    Text("SubBytes")
                }
                
                NavigationLink {
                    ShiftRowsAnimationView(viewModel:
                                            ShiftRowsViewModel(state: currentState,
                                                               result: resultShiftRows,
                                                               operationDetails: OperationDetails(operationName: .subBytes,
                                                                                                  isInverseMode: false,
                                                                                                  currentRound: 7),
                                                               shiftRowRounds: shiftRowsRound)
                    )
                    
                } label: {
                    Text("ShiftRows")
                }
                
                NavigationLink {
                    
                    MixColumnAnimationView(viewModel:
                                            MixColumnsViewModel(state: currentState,
                                                                result: resultMixColumns,
                                                                operationDetails: OperationDetails(operationName: .mixColumns,
                                                                                                   isInverseMode: false,
                                                                                                   currentRound: 7)))
                    
                } label: {
                    Text("MixColumns")
                }
                
                NavigationLink {
                    
                    AddRoundKeyAnimationView(viewModel:
                                                AddRoundKeyViewModel(state: currentState,
                                                                     key: key,
                                                                     result: resultSubBytes,
                                                                     operationDetails: OperationDetails(operationName: .addRoundKey,
                                                                                                        isInverseMode: false,
                                                                                                        currentRound: 7)))
                    
                } label: {
                    Text("AddRoundKey")
                }
                
                NavigationLink {
                    KeyExpansionAnimationView(viewModel: KeyExpansionViewModel(roundKeys: roundKeys128Bit.split2DArrayIntoChunks(chunkSize: 4),
                                                                               operationDetails: OperationDetails(operationName: .keyExpansion,
                                                                                                                  isInverseMode: false,
                                                                                                                  currentRound: -1),
                                                                               keyExpRounds: roundKeysHistory128Bit,
                                                                               keySize: AESKeySize(rawValue: 4)!))
                } label: {
                    Text("KeyExpansion 128 Bit")
                }
                
                
                NavigationLink {
                    KeyExpansionAnimationView(viewModel: KeyExpansionViewModel(roundKeys: roundKeys192Bit.split2DArrayIntoChunks(chunkSize: 4),
                                                                               operationDetails: OperationDetails(operationName: .keyExpansion,
                                                                                                                  isInverseMode: false,
                                                                                                                  currentRound: -1),
                                                                               keyExpRounds: roundKeysHistory192Bit,
                                                                               keySize: AESKeySize(rawValue: 6)!))
                } label: {
                    Text("KeyExpansion 192 Bit")
                }
                
                NavigationLink {
                    KeyExpansionAnimationView(viewModel: KeyExpansionViewModel(roundKeys: roundKeys256Bit.split2DArrayIntoChunks(chunkSize: 4),
                                                                               operationDetails: OperationDetails(operationName: .keyExpansion,
                                                                                                                  isInverseMode: false,
                                                                                                                  currentRound: -1),
                                                                               keyExpRounds: roundKeysHistory256Bit,
                                                                               keySize: AESKeySize(rawValue: 8)!))
                } label: {
                    Text("KeyExpansion 256 Bit")
                }
                
            }
        }
        .onAppear(perform: computeValues)
    }
    
    func computeValues() {
        resultSubBytes = currentState
        resultShiftRows = currentState
        resultMixColumns = currentState
        resultAddRoundKey = currentState
        
        let state = AESState(math: math)
        
        state.subBytes(state: &resultSubBytes, isInverse: false)
        shiftRowsRound = state.shiftRows(state: &resultShiftRows, isInverse: false)
        state.mixColumns(state: &resultMixColumns, isInverse: false)
        state.addRoundKey(state: &resultAddRoundKey, key: key)
        
        let keySched = AESKeySchedule(math: math)
        keySched.keyExpansion(key: key128Bit)
        roundKeys128Bit = keySched.getRoundKeys()
        roundKeysHistory128Bit = keySched.getDetailedKeySchedule()
        
        keySched.keyExpansion(key: key192Bit)
        roundKeys192Bit = keySched.getRoundKeys()
        roundKeysHistory192Bit = keySched.getDetailedKeySchedule()
        
        keySched.keyExpansion(key: key256Bit)
        roundKeys256Bit = keySched.getRoundKeys()
        roundKeysHistory256Bit = keySched.getDetailedKeySchedule()
        
    }
}
