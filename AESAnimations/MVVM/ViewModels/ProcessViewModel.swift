//
//  ProcessViewModel.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 30.09.24.
//

import SwiftUI

class ProcessViewModel: AnimationViewModel {
    // MARK: - Properties
    let operationDetails: OperationDetails
    let aesState: AESState
    let aesCipher: AESCipher
    
    var copyOfState: [[Byte]] = []
    
    @Published var ballPosition: CGFloat = -60
    @Published var ballPositionX: CGFloat = 0
    
    @Published var showCipherHistory = false
    @Published var showRoundKeyColumn = 0.0
    @Published var showAnimationView = false
    @Published var showFullKey = false
    
    @Published var selectedKeyPath: KeyPath<CipherRound, [[Byte]]> = \.roundKey
    
    @Published var currentRoundKey: [[Byte]] = []
    @Published var currentState: [[Byte]] = []
    @Published var currentRoundNumber = 0
    @Published var highlightOperation: [Int : [Bool]] = [
        0: [false],
        1: [false, false, false, false],
        2: [false, false, false, false],
        3: [false, false, false, false],
    ]
    
    @Published var animationControl = AnimationControl()
    var animationTask: Task<Void, Never>? = nil
    var animationSteps: [AnimationStep] = []
    var reverseAnimationSteps: [AnimationStep] = []
    
    @Published var horizontalLineHeight: CGFloat = 0
    // MARK: - Computed Properties
    var state: [[Byte]] { aesCipher.input.convertToState() }
    var key: [[Byte]] { aesCipher.key.convertToState() }
    var result: [[Byte]] { aesCipher.result }
    var cipherHistory: [CipherRound] { aesCipher.getCipherHistory }
    
    // MARK: Operation ViewModels
    var keyViewModel: KeyViewModel { KeyViewModel(aesCipher: aesCipher) }
    var shiftRowsViewModel: ShiftRowsViewModel {
        var result = currentState
        let shiftRowsHistory = aesState.shiftRows(state: &result, isInverse: operationDetails.isInverseMode)
        
        return ShiftRowsViewModel(state: currentState,
                                  result: result,
                                  operationDetails: OperationDetails(operationName: .shiftRows,
                                                                     isInverseMode: operationDetails.isInverseMode,
                                                                     currentRound: currentRoundNumber),
                                  shiftRowRounds: shiftRowsHistory)
    }
    var subBytesViewModel: SubBytesViewModel {
        var result = currentState
        aesState.subBytes(state: &result, isInverse: operationDetails.isInverseMode)
        
        return SubBytesViewModel(state: currentState,
                                 result: result,
                                 operationDetails: OperationDetails(operationName: .subBytes,
                                                                    isInverseMode: operationDetails.isInverseMode,
                                                                    currentRound: currentRoundNumber))
    }
    var mixColumnsViewModel: MixColumnsViewModel {
        var result = currentState
        aesState.mixColumns(state: &result, isInverse: operationDetails.isInverseMode)
        
        return MixColumnsViewModel(state: currentState,
                                   result: result,
                                   operationDetails: OperationDetails(operationName: .mixColumns,
                                                                      isInverseMode: operationDetails.isInverseMode,
                                                                      currentRound: currentRoundNumber))
    }
    var addRoundKeyViewModel: AddRoundKeyViewModel {
        var result = currentState
        aesState.addRoundKey(state: &result, key: currentRoundKey)
        
        return AddRoundKeyViewModel(state: currentState,
                                    key: currentRoundKey,
                                    result: result,
                                    operationDetails: OperationDetails(operationName: .addRoundKey,
                                                                       isInverseMode: operationDetails.isInverseMode,
                                                                       currentRound: currentRoundNumber))
    }
    
    // MARK: - Initializer
    init(operationDetails: OperationDetails, aesState: AESState, aesCipher: AESCipher) {
        self.operationDetails = operationDetails
        self.aesState = aesState
        self.aesCipher = aesCipher
        
        currentState = cipherHistory[0].startOfRound
        currentRoundKey = cipherHistory[0].roundKey
    }
    
    // MARK: - Animation Data
    var phaseOne: [ProcessPhaseAnimation] {
        operationDetails.isInverseMode ?
        [
            ProcessPhaseAnimation(index: 0,
                                  keyPath: \.afterAddRound,
                                  operation: "AddRoundKey",
                                  color: .green),
            ProcessPhaseAnimation(index: 1,
                                  keyPath: \.afterShiftRows,
                                  operation: "InvShiftRows",
                                  color: .orange),
            ProcessPhaseAnimation(index: 2,
                                  keyPath: \.afterSubBytes,
                                  operation: "InvSubBytes",
                                  color: .red),
        ]
        : [
            ProcessPhaseAnimation(index: 0,
                                  keyPath: \.afterAddRound,
                                  operation: "AddRoundKey",
                                  color: .green)
        ]
    }
    var phaseTwo: [ProcessPhaseAnimation] {
        operationDetails.isInverseMode ?
        [
            ProcessPhaseAnimation(index: 0,
                                  keyPath: \.afterAddRound,
                                  operation: "1 - AddRoundKey",
                                  color: .green),
            
            ProcessPhaseAnimation(index: 1,
                                  keyPath: \.afterMixColumns,
                                  operation: "2 - Inv MixColumns",
                                  color: .yellow),
            
            ProcessPhaseAnimation(index: 2,
                                  keyPath: \.afterShiftRows,
                                  operation: "3 - Inv ShiftRows",
                                  color: .orange),
            
            ProcessPhaseAnimation(index: 3,
                                  keyPath: \.afterSubBytes,
                                  operation: "4 - Inv SubBytes",
                                  color: .red),
            
        ]
        : [
            ProcessPhaseAnimation(index: 0,
                                  keyPath: \.afterSubBytes,
                                  operation: "1 - SubBytes",
                                  color: .red),
            
            ProcessPhaseAnimation(index: 1,
                                  keyPath: \.afterShiftRows,
                                  operation: "2 - ShiftRows",
                                  color: .orange),
            
            ProcessPhaseAnimation(index: 2,
                                  keyPath: \.afterMixColumns,
                                  operation: "3 - MixColumns",
                                  color: .yellow),
            
            ProcessPhaseAnimation(index: 3,
                                  keyPath: \.afterAddRound,
                                  operation: "4 - AddRoundKey",
                                  color: .green),
        ]
    }
    var phaseThree: [ProcessPhaseAnimation] {
        operationDetails.isInverseMode ? [
            ProcessPhaseAnimation(index: 0,
                                  keyPath: \.afterAddRound,
                                  operation: "AddRoundKey",
                                  color: .green)
        ] : [
            ProcessPhaseAnimation(index: 0,
                                  keyPath: \.afterSubBytes,
                                  operation: "SubBytes",
                                  color: .red),
            
            ProcessPhaseAnimation(index: 1,
                                  keyPath: \.afterShiftRows,
                                  operation: "ShiftRows",
                                  color: .orange),
            
            ProcessPhaseAnimation(index: 2,
                                  keyPath: \.afterAddRound,
                                  operation: "AddRoundKey",
                                  color: .green)
        ]
    }
    
    // MARK: - Animation Steps Creation
    /// Creates the animation steps for the entire animation sequence.
    ///
    /// This function is called when the view appears, and it ensures that the `animationSteps` and `reverseAnimationSteps` arrays
    /// are filled only once. The function calculates and appends the animation steps based on the Rjindael-Algorithm
    ///
    /// - Parameter geometry: The `GeometryProxy` object used to calculate the view's layout for positioning animations.
    func createAnimationSteps(with geometry: GeometryProxy) {
        guard animationSteps.isEmpty else { return }
        
        animationSteps.append(
            AnimationStep(animation: { withAnimation(.linear(duration: 0.5)) { self.ballPosition += 50 }}, delay: 250_000_000)
        )
        
        // Phase Zero
        animationSteps.append(contentsOf: addKeyExpansionSteps())
        
        // Phase One
        for process in phaseOne {
            animationSteps.append(contentsOf: highlightAndMoveBall(phase: 1, index: process.index))
            animationSteps.append(updateStateStep(phase: 1,
                                                  index: process.index,
                                                  round: 0,
                                                  stepKey: process.keyPath))
        }
        
        animationSteps.append(contentsOf: moveToMainCipher())
        
        // Phase Two
        for round in 1..<aesCipher.nrOfRounds { animationSteps.append(contentsOf: createAESLoop(round: round)) }
        
        animationSteps.append(contentsOf: moveToLastSteps())
        
        // Phase Three
        for process in phaseThree {
            animationSteps.append(contentsOf: highlightAndMoveBall(phase: 3, index: process.index))
            animationSteps.append(updateStateStep(phase: 3,
                                                  index: process.index,
                                                  round: aesCipher.nrOfRounds,
                                                  stepKey: process.keyPath)
            )
        }
        
        animationSteps.append(AnimationStep { withAnimation { self.showRoundKeyColumn = 0.0 } })
        
        startAnimations()
    }
    
    func addKeyExpansionSteps() -> [AnimationStep] {
        let normalSteps = highlightAndMoveBall(phase: 0, index: 0) + [
            AnimationStep { withAnimation { self.highlightOperation[0]?[0] = false } },
            AnimationStep { withAnimation { self.showRoundKeyColumn = 1.0 } },
            AnimationStep(animation: { withAnimation(.linear(duration: 0.25)) { self.ballPosition += 15 } }, delay: 125_000_000)
        ]
        
        return normalSteps
    }
    
    func moveToMainCipher() -> [AnimationStep] {
        let normalSteps = [
            AnimationStep { withAnimation { self.currentRoundKey = self.cipherHistory[1].roundKey } },
            AnimationStep { withAnimation { self.currentRoundNumber += 1 } },
            AnimationStep(animation: { withAnimation(.linear(duration: 0.25)) { self.ballPosition += 15 } }, delay: 125_000_000)
        ]
        
        return normalSteps
    }
    
    func moveToLastSteps() -> [AnimationStep] {
        return [
            AnimationStep {
                withAnimation {
                    self.currentState = self.cipherHistory[self.aesCipher.nrOfRounds].startOfRound
                    self.currentRoundKey = self.cipherHistory[self.aesCipher.nrOfRounds].roundKey
                    self.currentRoundNumber += 1
                }
            },
            
            AnimationStep(animation: { withAnimation(.linear(duration: 0.25)) { self.ballPosition += 10 } },
                          delay: 125_000_000)
        ]
    }
    
    func createAESLoop(round: Int) -> [AnimationStep] {
        // Create an empty array to hold the steps
        var normalSteps: [AnimationStep] = []
        
        for process in phaseTwo  {
            normalSteps += highlightAndMoveBall(phase: 2, index: process.index)
            normalSteps.append(updateStateStep(phase: 2, index: process.index, round: round, stepKey: process.keyPath))
        }
        
        normalSteps.append(AnimationStep {
            withAnimation {
                if round + 1 < self.aesCipher.nrOfRounds {
                    self.currentRoundKey = self.cipherHistory[round + 1].roundKey
                }
            }
        })
        
        normalSteps.append(AnimationStep(animation: { withAnimation(.linear(duration: 0.5)) { self.ballPosition += 10 } },
                                         delay: 250_000_000))
        
        if round < aesCipher.nrOfRounds - 1 { normalSteps.append(contentsOf: moveBallToLoop()) }
        
        return normalSteps
    }
    
    func moveBallToLoop() -> [AnimationStep] {
        return [
            AnimationStep(animation: {
                withAnimation(.linear(duration: 0.5)) { self.ballPositionX += 125 }
            }, delay: short),
            AnimationStep(animation: {
                withAnimation(.linear(duration: 0.25)) { self.ballPosition -= 250 }
            }, delay: 250_000_000),
            AnimationStep(animation: {
                withAnimation(.linear(duration: 0.5)) { self.ballPositionX -= 125 }
                withAnimation { self.currentRoundNumber += 1 }
            }, delay: short)
        ]
    }
    
    func highlightAndMoveBall(phase: Int, index: Int) -> [AnimationStep] {
        return [
            AnimationStep(animation: {
                withAnimation { self.highlightOperation[phase]?[index] = true }
                withAnimation(.linear(duration: 0.5)) { self.ballPosition += 30 }
            }, delay: 250_000_000),
            
            AnimationStep(animation: {
                withAnimation(.linear(duration: 0.5)) { self.ballPosition += 30 }
            }, delay: 250_000_000),
        ]
    }
    
    private func updateStateStep(phase: Int, index: Int, round: Int, stepKey: KeyPath<CipherRound, [[Byte]]>) -> AnimationStep {
        return AnimationStep {
            withAnimation {
                self.highlightOperation[phase]?[index] = false
                self.currentState = self.cipherHistory[round][keyPath: stepKey]
            }
        }
    }
    
    // MARK: - Animation Control
    /// Resets all variables related to the animation to their initial values.
    ///
    /// This function reinitializes the values of various animation-related variables, such as the ball positions, round number, current state and
    /// current round Key . It is used to reset the animation to the starting point.
    ///
    /// The `newState` parameter is included for potential  modification after the animation,
    /// but in this case, it is not utilized.
    ///
    /// - Parameters:
    ///   - newState: The modified key after the animation. This parameter is not used in this function.
    ///   - showResult: Controls whether the result is visible after resetting.
    func resetAnimationState(state newState: [[Byte]], showResult: Double) {
        withAnimation {
            ballPosition = showResult == 1.0 ? horizontalLineHeight : -60
            ballPositionX = 0
            currentRoundNumber = 0
            currentState = showResult == 1.0 ? result : cipherHistory[0].startOfRound
            showRoundKeyColumn = 0.0
            highlightOperation = [
                0: [false],
                1: [false, false, false, false],
                2: [false, false, false, false],
                3: [false, false, false, false],
            ]
            
            currentRoundNumber = showResult == 1.0 ? aesCipher.nrOfRounds : 0
        }
    }
}

