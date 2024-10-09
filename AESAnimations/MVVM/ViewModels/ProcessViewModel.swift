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
    @Published var highlightOperation: [Int : [Bool]] = [
        0: [false],
        1: [false, false, false],
        2: [false, false, false, false],
        3: [false, false, false],
    ]
    
    @Published var currentRoundNumber = 0
    @Published var currentRoundKeyNumber = 0
    
    @Published var animationControl = AnimationControl()
    var animationTask: Task<Void, Never>? = nil
    var animationSteps: [AnimationStep] = []
    var reverseAnimationSteps: [AnimationStep] = []
    
    @Published var horizontalLineHeight: CGFloat = 0
    
    @Published var ballIsUp = false
    @Published var mainRoundDistance: CGFloat = 250
    @Published var distanceCounter: CGFloat = 0
    
    // MARK: - Operation ViewModels
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
    
    // Computed Properties
    var state: [[Byte]] { aesCipher.input.convertToState() }
    var key: [[Byte]] { aesCipher.key.convertToState() }
    var result: [[Byte]] { aesCipher.result }
    var cipherHistory: [CipherRound] { aesCipher.getCipherHistory }
    
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
                                  reverseKeyPath: \.startOfRound,
                                  operation: "AddRoundKey",
                                  color: .green),
            ProcessPhaseAnimation(index: 1,
                                  keyPath: \.afterShiftRows,
                                  reverseKeyPath: \.afterAddRound,
                                  operation: "InvShiftRows",
                                  color: .orange),
            ProcessPhaseAnimation(index: 2,
                                  keyPath: \.afterSubBytes,
                                  reverseKeyPath: \.afterShiftRows,
                                  operation: "InvSubBytes",
                                  color: .red),
        ]
        : [
            ProcessPhaseAnimation(index: 0,
                                  keyPath: \.afterAddRound,
                                  reverseKeyPath: \.startOfRound,
                                  operation: "AddRoundKey",
                                  color: .green)
        ]
    }
    var phaseTwo: [ProcessPhaseAnimation] {
        operationDetails.isInverseMode ?
        [
            ProcessPhaseAnimation(index: 0,
                                  keyPath: \.afterAddRound,
                                  reverseKeyPath: \.startOfRound,
                                  operation: "1 - AddRoundKey",
                                  color: .green),
            
            ProcessPhaseAnimation(index: 1,
                                  keyPath: \.afterMixColumns,
                                  reverseKeyPath: \.afterAddRound,
                                  operation: "2 - Inv MixColumns",
                                  color: .yellow),
            
            ProcessPhaseAnimation(index: 2,
                                  keyPath: \.afterShiftRows,
                                  reverseKeyPath: \.afterMixColumns,
                                  operation: "3 - Inv ShiftRows",
                                  color: .orange),
            
            ProcessPhaseAnimation(index: 3,
                                  keyPath: \.afterSubBytes,
                                  reverseKeyPath: \.afterShiftRows,
                                  operation: "4 - Inv SubBytes",
                                  color: .red),
            
        ]
        : [
            ProcessPhaseAnimation(index: 0,
                                  keyPath: \.afterSubBytes,
                                  reverseKeyPath: \.startOfRound,
                                  operation: "1 - SubBytes",
                                  color: .red),
            
            ProcessPhaseAnimation(index: 1,
                                  keyPath: \.afterShiftRows,
                                  reverseKeyPath: \.afterSubBytes,
                                  operation: "2 - ShiftRows",
                                  color: .orange),
            
            ProcessPhaseAnimation(index: 2,
                                  keyPath: \.afterMixColumns,
                                  reverseKeyPath: \.afterShiftRows,
                                  operation: "3 - MixColumns",
                                  color: .yellow),
            
            ProcessPhaseAnimation(index: 3,
                                  keyPath: \.afterAddRound,
                                  reverseKeyPath: \.afterMixColumns,
                                  operation: "4 - AddRoundKey",
                                  color: .green),
        ]
    }
    var phaseThree: [ProcessPhaseAnimation] {
        operationDetails.isInverseMode ? [
            ProcessPhaseAnimation(index: 0,
                                  keyPath: \.afterAddRound,
                                  reverseKeyPath: \.startOfRound,
                                  operation: "AddRoundKey",
                                  color: .green)
        ] : [
            ProcessPhaseAnimation(index: 0,
                                  keyPath: \.afterSubBytes,
                                  reverseKeyPath: \.startOfRound,
                                  operation: "SubBytes",
                                  color: .red),
            
            ProcessPhaseAnimation(index: 1,
                                  keyPath: \.afterShiftRows,
                                  reverseKeyPath: \.afterSubBytes,
                                  operation: "ShiftRows",
                                  color: .orange),
            
            ProcessPhaseAnimation(index: 2,
                                  keyPath: \.afterAddRound,
                                  reverseKeyPath: \.afterShiftRows,
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
        
        phaseZeroSteps()
        createPhase(phase: 1, round: 0, phaseAnimations: phaseOne)
        
        let updateRoundNumber = updateRoundNumber()
        let moveToMainSteps = moveBall(for: 15, delay: 150_000_000)
        let moveToLastSteps = moveBall(for: 5, delay: 50_000_000)
        
        animationSteps.append(contentsOf: [moveToMainSteps.0, updateRoundNumber.0])
        reverseAnimationSteps.append(contentsOf: [moveToLastSteps.1, updateRoundNumber.1])
        
        phaseTwoSteps()
        
        animationSteps.append(contentsOf: [moveToLastSteps.0, updateRoundNumber.0])
        reverseAnimationSteps.append(contentsOf: [moveToMainSteps.1, updateRoundNumber.1])
        
        createPhase(phase: 3, round: aesCipher.nrOfRounds, phaseAnimations: phaseThree)
        addShowHideRoundKeySteps(hide: 0.0, show: 1.0)
        
        let moveToEnd = moveBall(for: 10, delay: 100_000_000)
        animationSteps.append(moveToEnd.0)
        reverseAnimationSteps.append(moveToEnd.1)
        
        startAnimations()
    }
    
    // MARK: - Animation Phase Creation Functions
    func phaseZeroSteps() { addSteps(addKeyExpansionSteps()) }
    
    func phaseTwoSteps() {
        for round in 1..<aesCipher.nrOfRounds { addSteps(createAESLoop(round: round)) }
    }
    
    func createPhase(phase: Int, round: Int, phaseAnimations: [ProcessPhaseAnimation]) {
        for process in phaseAnimations {
            addSteps(highlightOperation(phase: phase,
                                        index: process.index,
                                        round: round,
                                        keyPath: process.keyPath,
                                        reverseKeyPath: process.reverseKeyPath))
        }
    }
    
    func addKeyExpansionSteps() -> ([AnimationStep], [AnimationStep]) {
        let highlightMoveBallSteps = highlightOperation(phase: 0, index: 0)
        let firstRoundKey = AnimationStep { withAnimation { self.currentRoundKey = self.cipherHistory[0].roundKey } }
        
        let firstBallMove = moveBall(for: 50, delay: 250_000_000)
        let secondBallMove = moveBall(for: 15, delay: 150_000_000)
        
        let normalSteps = [firstBallMove.0] + highlightMoveBallSteps.0 +
        [
            AnimationStep { withAnimation { self.showRoundKeyColumn = 1.0 } },
            secondBallMove.0,
            firstRoundKey
        ]
        
        let reverseSteps = [firstBallMove.1] + highlightMoveBallSteps.1 +
        [
            AnimationStep { withAnimation { self.showRoundKeyColumn = 0.0 } },
            secondBallMove.1,
            firstRoundKey
        ]
        
        return (normalSteps, reverseSteps)
    }
    
    func addSteps(_ steps: ([AnimationStep], [AnimationStep])) {
        animationSteps.append(contentsOf: steps.0)
        reverseAnimationSteps.append(contentsOf: steps.1)
    }
    
    func addShowHideRoundKeySteps(hide: Double, show: Double) {
        animationSteps.append(AnimationStep { withAnimation { self.showRoundKeyColumn = hide } })
        reverseAnimationSteps.append(AnimationStep { withAnimation { self.showRoundKeyColumn = show } })
    }
    
    // MARK: - Animation Steps Helper Functions
    func createAESLoop(round: Int) -> ([AnimationStep], [AnimationStep]) {
        var normalSteps: [AnimationStep] = []
        var reverseSteps: [AnimationStep] = []
        
        if round > 1 {
            let loopSteps = moveBallToLoop()
            let updateRoundNumber = AnimationStep {
                withAnimation {
                    if self.currentRoundNumber >= 2 { self.currentRoundNumber -= 1 }
                }
            }
            reverseSteps.append(updateRoundNumber)
            reverseSteps.append(contentsOf: loopSteps.1)
        }
        
        let moveUp = AnimationStep(animation: {
            await self.checkDoubleAnimation(for: 0)
            withAnimation(.linear) {
                let number = Int(self.ballPosition)
                let secondNumber = (number / 10) % 10
                if secondNumber % 2 == 0 { return }
                
                self.ballPosition -= 10
            }
        }, delay: 300_000_000)

        reverseSteps.append(moveUp)
        
        
        for process in phaseTwo  {
            let highlightOp = highlightOperation(phase: 2,
                                                 index: process.index,
                                                 round: round,
                                                 keyPath: process.keyPath,
                                                 reverseKeyPath: process.reverseKeyPath)
            normalSteps += highlightOp.0
            reverseSteps += highlightOp.1
            
        }
        let moveDown = AnimationStep(animation: {
            withAnimation(.linear) {
                let number = Int(self.ballPosition)
                let secondNumber = (number / 10) % 10
                if secondNumber % 2 != 0 { return }
                self.ballPosition += 10
                
            }
        }, delay: 300_000_000)
        normalSteps.append(moveDown)
        
        if round < aesCipher.nrOfRounds - 1 {
            let loopSteps = moveBallToLoop()
            let updateRoundNumber = updateRoundNumber()
            normalSteps.append(contentsOf: loopSteps.0)
            normalSteps.append(updateRoundNumber.0)
        }
        
        return (normalSteps, reverseSteps)
    }
    
    func moveBallToLoop() -> ([AnimationStep], [AnimationStep]) {
        let moveRight = AnimationStep(animation: {
            await self.checkDoubleAnimation(for: 150_000_000)
            withAnimation(.linear) {
                if self.ballPositionX > 0 { return }
                self.ballPositionX += 125
                self.ballIsUp = self.animationControl.isBackward ? true : false
            }
        }, delay: short)
        
        let moveUp = AnimationStep(animation: {
            await self.checkDoubleAnimation(for: 150_000_000)
            if self.ballIsUp { return }
            withAnimation(.linear) {
                self.ballPosition -= self.mainRoundDistance
                self.ballIsUp = true
            }
        }, delay: short)
        
        let moveDown = AnimationStep(animation: {
            await self.checkDoubleAnimation(for: 150_000_000)
            withAnimation(.linear) {
                if !self.ballIsUp { return }
                self.ballPosition += self.mainRoundDistance
                self.ballIsUp = false
            }
        }, delay: short)
        
        let moveLeft = AnimationStep(animation: {
            await self.checkDoubleAnimation(for: 150_000_000)
            withAnimation(.linear) {
                if self.ballPositionX <= 0 { return }
                self.ballPositionX -= 125
                self.ballIsUp = false
            }
        }, delay: short)
        
        let normalSteps = [moveRight, moveUp, moveLeft]
        let reverseSteps = [moveLeft, moveDown, moveRight]
        
        return (normalSteps, reverseSteps)
    }
    
    func moveBall(for positions: CGFloat,
                  delay: UInt64,
                  doubleDelay: UInt64 = 0) -> (AnimationStep, AnimationStep) {
        let normalStep = AnimationStep(animation: {
            await self.checkDoubleAnimation(for: doubleDelay)
            withAnimation(.linear) { self.ballPosition += positions }
        }, delay: delay)
        
        let reverseStep = AnimationStep(animation: {
            await self.checkDoubleAnimation(for: doubleDelay)
            withAnimation(.linear) { self.ballPosition -= positions }
        }, delay: delay)
        
        return (normalStep, reverseStep)
    }
    
    func highlightOperation(phase: Int,
                            index: Int,
                            round: Int? = nil,
                            keyPath: KeyPath<CipherRound, [[Byte]]>? = nil,
                            reverseKeyPath: KeyPath<CipherRound, [[Byte]]>? = nil) -> ([AnimationStep], [AnimationStep]) {
        
        let highlightOperation = AnimationStep { withAnimation { self.highlightOperation[phase]?[index] = true } }
        let moveBallFirst = moveBall(for: 30, delay: 250_000_000)
        let moveBallSecond = moveBall(for: 30, delay: 125_000_000)
        
        let normalSteps = [highlightOperation, moveBallFirst.0, moveBallSecond.0,
                           
                           AnimationStep {
            withAnimation {
                self.highlightOperation[phase]?[index] = false
                guard let keyPath, let round else { return }
                
                self.currentState = self.cipherHistory[round][keyPath: keyPath]
                if keyPath == \.afterAddRound {
                    self.currentRoundKey = self.cipherHistory[round + 1][keyPath: \.roundKey]
                    if self.currentRoundKeyNumber < self.aesCipher.nrOfRounds {
                        self.currentRoundKeyNumber += 1
                    }
                }
            }
        }
        ]
        
        let reverseSteps = [AnimationStep {
            withAnimation {
                self.highlightOperation[phase]?[index] = false
                guard let reverseKeyPath, let round else { return }
                self.currentState = self.cipherHistory[round][keyPath: reverseKeyPath]
                
                if keyPath == \.afterAddRound, round != 0 {
                    self.currentRoundKey = self.cipherHistory[round - 1].roundKey
                    self.currentRoundKeyNumber -= 1
                }
            }
        }, moveBallSecond.1, moveBallFirst.1, highlightOperation]
        
        return (normalSteps, reverseSteps)
    }
    
    func updateRoundNumber() -> (AnimationStep, AnimationStep) {
        return (AnimationStep { withAnimation { self.currentRoundNumber += 1 } },
                AnimationStep { withAnimation { self.currentRoundNumber -= 1 } }
        )
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
            currentState = showResult == 1.0 ? result : cipherHistory[0].startOfRound
            currentRoundKey = showResult == 1.0 ? cipherHistory[aesCipher.nrOfRounds].roundKey : cipherHistory[0].roundKey
            showRoundKeyColumn = 0.0
            highlightOperation = [
                0: [false],
                1: [false, false, false],
                2: [false, false, false, false],
                3: [false, false, false],
            ]
            
            currentRoundNumber = showResult == 1.0 ? aesCipher.nrOfRounds : 0
            currentRoundKeyNumber = showResult == 1.0 ? aesCipher.nrOfRounds : 0
        }
    }
}










