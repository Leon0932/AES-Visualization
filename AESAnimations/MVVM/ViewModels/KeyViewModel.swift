//
//  KeyViewModel.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 15.08.24.
//

import SwiftUI

class KeyViewModel: ObservableObject {
    // MARK: - Properties
    @Published var animateKeys: [Bool] = []
    
    @Published var showAnimationScreen = false
    @Published var showButtons = 0.0
    
    var animationTask: Task<Void, Never>? = nil
    
    var aesCipher: AESCipher
    
    // MARK: - Computed Properties
    var roundKeys: [[Byte]] { aesCipher.keySchedule.getRoundKeys() }
    var keyExpansionViewModel: KeyExpansionViewModel {
        let keySched = aesCipher.keySchedule
        
        return KeyExpansionViewModel(roundKeys: roundKeys.split2DArrayIntoChunks(chunkSize: 4),
                                     operationDetails: OperationDetails(operationName: .keyExpansion,
                                                                        isInverseMode: false,
                                                                        currentRound: -1),
                                     keyExpRounds: keySched.getDetailedKeySchedule(),
                                     keySize: keySched.getKeySize()!)
    }
    
    // MARK: - Initializer
    init(aesCipher: AESCipher) {
        self.aesCipher = aesCipher
        self.animateKeys = Array(repeating: false, count: roundKeys.count)
        
    }
    
    // MARK: - Animation Functions
    @MainActor
    func animateKeysFunction() {
        animationTask?.cancel()
        guard !animateKeys[0] else { return }
        
        animationTask = Task {
            for index in animateKeys.indices {
                try? await Task.sleep(nanoseconds: 500_000_000)
                withAnimation { self.animateKeys[index] = true }
            }
            
            try? await Task.sleep(nanoseconds: 500_000_000)
            withAnimation { self.showButtons = 1.0 }
        }
    }
}
