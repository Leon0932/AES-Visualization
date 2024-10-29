//
//  ShiftRowsViewModel.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 15.08.24.
//

import SwiftUI

class ShiftRowsViewModel: AnimationViewModel {
    // MARK: - Properties
    let operationDetails: OperationDetails
    
    // State Properties
    @Published var state: [[Byte]]
    let result: [[Byte]]
    let copyOfMatrix: [[Byte]]
    
    @Published var showShiftRounds = false
    var shiftRowRounds: [ShiftRowRound]
    
    // For ShiftRows-Animation
    @Published var positionCell: [[Position]] = Position.default2DPositions(rows: 4,
                                                                            cols: 4)
    @Published var isShiftTextVisible = [true, false, false, false]

    // Animation Control
    @Published var animationControl = AnimationControl()
    var animationTask: Task<Void, Never>? = nil
    var animationSteps: [AnimationStep] = []
    var reverseAnimationSteps: [AnimationStep] = []
    
    // Helper variables for the animations
    let boxSize: CGFloat = 70
    let spacing: CGFloat = 10
    var shiftRowsHelper: ShiftRowsHelper
    

    // MARK: - Initializer
    init(state: [[Byte]],
         result: [[Byte]],
         operationDetails: OperationDetails,
         shiftRowRounds: [ShiftRowRound]) {
        
        self.state = state
        self.result = result
        self.operationDetails = operationDetails
        self.shiftRowRounds = shiftRowRounds
        
        copyOfMatrix = state
        shiftRowsHelper = ShiftRowsHelper(boxSize: self.boxSize,
                                          spacing: self.spacing)
    }
    
    // MARK: - Animation Steps Creation
    /// Creates the animation steps for the entire animation sequence.
    ///
    /// This function is called when the view appears, and it ensures that the `animationSteps` and `reverseAnimationSteps` arrays
    /// are filled only once.
    ///
    /// - Parameter geometry: The `GeometryProxy` object used to calculate the view's layout for positioning animations.
    @MainActor
    func createAnimationSteps(with geometry: GeometryProxy) {
        let animations = performShiftRowsSequentially()
        animationSteps.append(contentsOf: animations.0)
        reverseAnimationSteps.append(contentsOf: animations.1)
        
        startAnimations()
    }
    
    // MARK: - Animation Steps Creation Helper Functions
    /// Performs the "Shift Rows" operation for a specific row in the state, repeating the operation a given number of times.
    /// This function executes the row shift animation for the specified row index and number of repetitions, returning
    /// two arrays of animation steps: one for the forward shift and one for reversing the operation.
    ///
    /// - Parameters:
    ///   - index: The index of the row in the state where the shift operation is performed.
    ///   - repetitions: The number of times the shift operation should be repeated for the specified row.
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///            and the second array handles the reverse animation.
    @MainActor
    private func performShiftRows(at index: Int, repetitions: Int) -> ([AnimationStep], [AnimationStep]) {
        var normalSteps: [AnimationStep] = []
        var reverseSteps: [AnimationStep] = []
        
        for currentRepetition in 0..<repetitions {
            let animations = shiftRow(at: index, currentRepetition: currentRepetition)
            normalSteps.append(contentsOf: animations.0)
            reverseSteps.append(contentsOf: animations.1)
        }
        
        return (normalSteps, reverseSteps)
        
    }
    
    /// Performs the shift operation for a specific row in the state, animating the process both forward and in reverse.
    ///
    /// This function moves the cells of the specified row during the "Shift Rows" operation in AES, adjusting their positions
    /// based on the shifting logic. It returns two sets of animation steps: one for shifting forward and one for reversing the shift.
    ///
    /// - Parameter index: The index of the row in the state where the shift operation is performed.
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///            and the second array handles the reverse animation.
    @MainActor
    func shiftRow(at index: Int, currentRepetition: Int) -> ([AnimationStep], [AnimationStep]) {
        let animationSteps = [
            AnimationStep(animation: {
                withAnimation {
                    self.positionCell[index][0].x = self.shiftRowsHelper.middleOffset
                    self.positionCell[index][0].y = -100
                }
            }, delay: normal),
            AnimationStep(animation: {
                withAnimation {
                    for i in 1...3 {
                        self.positionCell[index][i].x = -self.shiftRowsHelper.boxSizeWithSpacing
                    }
                }
            }, delay: normal),
            AnimationStep {
                withAnimation {
                    self.positionCell[index][0].y = 0
                    self.positionCell[index][0].x = self.shiftRowsHelper.returnOffset
                }
            },
            AnimationStep {
                // Small delay, as the animation in the view
                // is otherwise buggy
                await self.sleep(for: self.normal)
                self.state[index] = self.shiftRowRounds[index - 1].shifts[currentRepetition]
                self.positionCell[index] = Position.default1DPositions(count: 4)
                
            }
        ]
        
        let reverseAnimationSteps = [
            AnimationStep {
                if self.positionCell[index][0].x == self.shiftRowsHelper.boxSizeWithSpacing {
                    await self.sleep(for: self.normal)
                    
                    let shiftRounds = self.shiftRowRounds[index - 1]
      
                    if currentRepetition == 0 {
                        self.state[index] = shiftRounds.temp
                    } else {
                        self.state[index] = shiftRounds.shifts[currentRepetition - 1]
                    }
                    
                    self.positionCell[index] = Position.default1DPositions(count: 4)
                    
                    return
                }
                self.positionCell[index] = Position.default1DPositions(count: 4)
            },
            AnimationStep(animation: {
                withAnimation {
                    if self.positionCell[index][0].x == self.shiftRowsHelper.boxSizeWithSpacing  {
                        self.positionCell[index][3].y = 0
                        self.positionCell[index][3].x = -self.shiftRowsHelper.returnOffset
                        return
                    }
                    
                    if self.positionCell[index][0].x == self.shiftRowsHelper.middleOffset {
                        for i in 1...3 {
                            self.positionCell[index][i].x = 0
                        }
                    }
                    
                    self.positionCell[index][0].x = 0
                    self.positionCell[index][0].y = 0
                }
            }, delay: normal),
            AnimationStep(animation: {
                withAnimation {
                    if self.positionCell[index][1].x == -self.shiftRowsHelper.boxSizeWithSpacing {
                        for i in 1...3 {
                            self.positionCell[index][i].x = 0  // Reset if incomplete
                        }
                    } else {
                        for i in 0...2 {
                            self.positionCell[index][i].x = self.shiftRowsHelper.boxSizeWithSpacing
                        }
                    }
                    
                }
            }, delay: normal),
            AnimationStep(animation: {
                withAnimation {
                    if self.positionCell[index][0].x != self.shiftRowsHelper.middleOffset || self.positionCell[index][0].y != -100 {
                        self.positionCell[index][3].x = -self.shiftRowsHelper.middleOffset
                        self.positionCell[index][3].y = -100
                    } else {
                        self.positionCell[index][0].x = 0
                        self.positionCell[index][0].y = 0
                        
                    }
                }
            }, delay: normal)
        ]
        
        return (animationSteps, reverseAnimationSteps)
    }
    
    /// Performs the "Shift Rows" operation sequentially for each row in the state, animating the process step-by-step.
    ///
    /// This function handles both the forward and reverse animations for shifting rows. It dynamically adjusts the visibility
    /// of the shift text for each row based on the current animation state and performs the required number of shifts
    /// depending on the mode (normal or inverse).
    ///
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///            and the second array handles the reverse animation.
    @MainActor
    private func performShiftRowsSequentially() -> ([AnimationStep], [AnimationStep])  {
        var normalSteps: [AnimationStep] = []
        var reverseSteps: [AnimationStep] = []
        
        let startStep = AnimationStep { withAnimation { self.isShiftTextVisible[0] = false } }
        
        normalSteps.append(startStep)
        reverseSteps.append(startStep)
        
        let configs: [(index: Int, repetitions: Int)] = operationDetails.isInverseMode
        ? [(1, 3), (2, 2), (3, 1)]
        : [(1, 1), (2, 2), (3, 3)]
        
        for (i, config) in configs.enumerated() {
            
            if i > 0 {
                normalSteps.append(AnimationStep { self.isShiftTextVisible[configs[i - 1].index] = false })
                reverseSteps.append(AnimationStep { self.isShiftTextVisible[configs[i - 1].index] = true })
            }
            
            normalSteps.append(
                AnimationStep(animation: { self.isShiftTextVisible[config.index] = true},
                              delay: short)
            )
            reverseSteps.append(AnimationStep { self.isShiftTextVisible[config.index] = false })
            
            let animations = performShiftRows(at: config.index, repetitions: config.repetitions)
            
            normalSteps.append(contentsOf: animations.0)
            reverseSteps.append(contentsOf: animations.1)
        }
        
        normalSteps.append(AnimationStep { self.isShiftTextVisible[configs.last!.index] = false })
        reverseSteps.append(AnimationStep { self.isShiftTextVisible[configs.last!.index] = true })
        
        return (normalSteps, reverseSteps)
    }
    
    // MARK: - Animation Control
    /// Resets all variables related to the animation to their initial state.
    ///
    /// This function reinitializes the state of various animation-related variables, such as the positions of
    /// the cells, visibility flags. It is used to reset the animation to the starting point.
    /// The `newState` parameter is included for  state modification after the animation.
    ///
    /// - Parameters:
    ///   - newState: The modified state after the animation.
    ///   - showResult: Controls whether the new state is visible or not after resetting.
    func resetAnimationState(state newState: [[Byte]], showResult: Double) {
        withAnimation {
            state = newState
            isShiftTextVisible = Array.create1DArray(repeating: false, count: 4)
            positionCell = Position.default2DPositions(rows: 4, cols: 4)
        }
    }
    
    // MARK: - Toggle Functions
    func toggleShiftRounds() {
        showShiftRounds.toggle()
    }
}
