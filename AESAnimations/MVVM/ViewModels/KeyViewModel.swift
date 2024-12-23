//
//  KeyViewModel.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 15.08.24.
//

import SwiftUI

/// ViewModel responsible for displaying round keys in an animation.
/// Also manages navigation to the `KeyExpansionAnimationView`.
final class KeyViewModel: ObservableObject {
    // MARK: - Properties
    @Published var animateKeys: [Bool] = []
    
    @Published var showAnimationScreen = false
    @Published var showButtons = 0.0
    
    // To execute code within a synchronous function
    var animationTask: Task<Void, Never>? = nil
    
    var aesCipher: AESCipher
    
    // MARK: - Computed Properties
    var roundKeys: [[Byte]] { aesCipher.getRoundKeys }
    var keyExpansionViewModel: KeyExpansionViewModel {
        KeyExpansionViewModel(roundKeys: roundKeys.split2DArrayIntoChunks(chunkSize: 4),
                              operationDetails: OperationDetails(operationName: .keyExpansion,
                                                                 isInverseMode: false,
                                                                 currentRound: -1),
                              keyExpRounds: aesCipher.getDetailedKeySchedule,
                              keySize: aesCipher.getKeySize)
    }
    
    // MARK: - Initializer
    init(aesCipher: AESCipher) {
        self.aesCipher = aesCipher
        self.animateKeys = Array(repeating: false, count: roundKeys.count)
        
    }
    
    // MARK: - Animation Functions
    /// Animates the display of round keys at intervals of 250 milliseconds.
    /// Cancels any existing animation task before starting a new one.
    @MainActor
    func animateKeysFunction() {
        animationTask?.cancel()
        guard !animateKeys[0] else { return }
        
        animationTask = Task {
            for index in animateKeys.indices {
                try? await Task.sleep(nanoseconds: 250_000_000)
                withAnimation { self.animateKeys[index] = true }
            }
            
            try? await Task.sleep(nanoseconds: 250_000_000)
            withAnimation { self.showButtons = 1.0 }
        }
    }
}
