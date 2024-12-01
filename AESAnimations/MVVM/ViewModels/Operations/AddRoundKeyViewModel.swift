//
//  AddRoundKeyViewModel.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 18.08.24.
//

import SwiftUI

class AddRoundKeyViewModel: AnimationViewModel {
    // MARK: - Properties
    let operationDetails: OperationDetails
    
    // State variables
    @Published var state: [[Byte]]
    var copyOfMatrix: [[Byte]]
    let key: [[Byte]]
    let result: [[Byte]]
    
    // Positions for moving the cells
    @Published var positionState: [[Position]] = Position.default2DPositions(rows: 4,
                                                                             cols: 4)
    @Published var positionKey: [[Position]] = Position.default2DPositions(rows: 4,
                                                                           cols: 4)
    
    @Published var resultOfAdd: Byte = 0x00
    
    // Flags for the view
    @Published var showNewState: [[Double]] = Array.create2DArray(repeating: 0.0,
                                                                  rows: 4,
                                                                  cols: 4)
    @Published var showXOR = 0.0
    @Published var showEqual = 0.0
    @Published var showResult = 0.0
    
    // Controling the animation
    @Published var animationControl = AnimationControl()
    var animationData = AnimationData()
    
    // Constants
    private let verticalOffset: CGFloat = 140
    private let horizontalSpacing: CGFloat = 60
    var isPad13Size = false
    
    // MARK: - Initializer
    init(state: [[Byte]],
         key: [[Byte]],
         result: [[Byte]],
         operationDetails: OperationDetails) {
        self.state = state
        self.key = key
        self.result = result
        self.operationDetails = operationDetails
        
        copyOfMatrix = state
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
        let width = geometry.size.width
        for row in 0..<4 {
            for col in 0..<4 {
                let animations = animateRoundKeyAddition(row: row, col: col, width: width)
                animationData.animationSteps.append(contentsOf: animations.0)
                animationData.reverseAnimationSteps.append(contentsOf: animations.1)
            }
        }
        
        handleAnimationStart()
    }
    
    /// Animates the process of adding a round key in the AES encryption round.
    ///
    /// This function creates a sequence of animation steps, both for the normal
    /// and reverse animation flows, to visually represent the round key addition process.
    ///
    /// - Parameters:
    ///   - row: The row index of the state / key where the animation occurs.
    ///   - col: The column index of the state / key where the animation occurs.
    ///   - width: The width of the animation view, used to calculate the positions.
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///   and the second array handles the reverse animation.
    @MainActor
    private func animateRoundKeyAddition(row: Int, col: Int, width: CGFloat) -> ([AnimationStep], [AnimationStep]) {
        let normalSteps = [
            AnimationStep { self.resultOfAdd = self.result[row][col] },
            AnimationStep(animation: {
                if self.positionState[row][col].y == 0 || self.positionKey[row][col].y == 0 {
                    await self.updatePosition(row: row, col: col, width: width, isX: false)
                }
            }, delay: normal),
            AnimationStep(animation: { await self.updatePosition(row: row, col: col, width: width, isX: true) }, delay: short),
            AnimationStep(animation: { self.changeVisibility(value: 1.0) }, delay: normal),
            AnimationStep(animation: { withAnimation { self.showNewState[row][col] = 1.0 } }, delay: short),
            AnimationStep(animation: { self.changeVisibility(value: 0.0) },  delay: short),
            AnimationStep(animation: { await self.resetPosition(row: row, col: col, isX: true) }, delay: short),
            AnimationStep(animation: { await self.resetPosition(row: row, col: col, isX: false) }, delay: short),
        ]
        
        let reverseSteps = [
            AnimationStep(animation: { await self.resetPosition(row: row, col: col, isX: false) }, delay: short),
            AnimationStep(animation: { await self.resetPosition(row: row, col: col, isX: true) }, delay: normal),
            AnimationStep(animation: { self.changeVisibility(value: 0.0) }, delay: normal),
            AnimationStep(animation: { withAnimation { self.showNewState[row][col] = 0.0 } }, delay: short),
            AnimationStep(animation: { self.changeVisibility(value: 1.0) }, delay: normal),
            AnimationStep(animation: { await self.updatePosition(row: row, col: col, width: width, isX: true) }, delay: normal),
            
            AnimationStep(animation: {
                if self.positionState[row][col].y == 0 || self.positionKey[row][col].y == 0 {
                    await self.updatePosition(row: row, col: col, width: width, isX: false)
                }
            }, delay: short),
            
            AnimationStep { self.resultOfAdd = self.result[row][col] }
        ]
        
        return (normalSteps, reverseSteps)
    }
    
    // MARK: - Modifier Helper Functions
    /// Updates the position of an element in the state / key during an animation.
    ///
    /// This function adjusts either the x or y position of the state / key element based on the given parameters.
    /// The position update is animated, and once the position update is completed, the function checks if
    /// `isDouble` is active to introduce a short delay, using the `checkDoubleAnimation` function.
    ///
    /// - Parameters:
    ///   - row: The row index of the state / key where the animation occurs.
    ///   - col: The column index of the state / key where the animation occurs.
    ///   - width: The width of the animation view, used to calculate the positions.
    ///   - isX: A Boolean value indicating whether the x-axis or y-axis should be updated.
    @MainActor
    private func updatePosition(row: Int, col: Int, width: CGFloat, isX: Bool) async {
        withAnimation {
            if isX {
                let widthPosition = self.isPad13Size ? 0.3525 : 0.345
                self.positionState[row][col].x = width * widthPosition - CGFloat(col) * self.horizontalSpacing
                self.positionKey[row][col].x = -(width * 0.475) + CGFloat(3 - col) * self.horizontalSpacing
                
            } else {
                self.positionState[row][col].y -= self.verticalOffset + CGFloat(row) * self.horizontalSpacing
                self.positionKey[row][col].y -= self.verticalOffset + CGFloat(row) * self.horizontalSpacing
                
            }
        }
        
        await checkDoubleAnimation()
    }
    
    /// Resets the position of an element in the state / key during an animation
    ///
    /// This function resets either the x or y position of the state / key element based on the given parameters.
    /// The position update is animated, and once the position update is completed, the function checks if
    /// `isDouble` is active to introduce a short delay, using the `checkDoubleAnimation` function.
    ///
    /// - Parameters:
    ///   - row: The row index of the state / key where the animation occurs.
    ///   - col: The column index of the state / key where the animation occurs.
    ///   - isX: A Boolean value indicating whether the x-axis or y-axis should be updated.
    @MainActor
    private func resetPosition(row: Int, col: Int, isX: Bool) async {
        withAnimation {
            if isX {
                self.positionState[row][col].x = 0
                self.positionKey[row][col].x = 0
            } else {
                self.positionState[row][col].y = 0
                self.positionKey[row][col].y = 0
            }
        }
        
        await checkDoubleAnimation()
    }
    
    /// Changes the visibility of certain elements in the view during the animation.
    ///
    /// This function updates the visibility of the XOR, Equal, and Result symbols based on the provided value.
    ///
    /// - Parameter value: The visibility value. A value of `1.0` makes the column visible, and `0.0` hides it.
    private func changeVisibility(value: Double) {
        withAnimation {
            showXOR = value
            showEqual = value
            showResult = value
        }
    }
    
    // MARK: - Animation Control
    /// Resets all variables related to the animation to their initial state.
    ///
    /// This function reinitializes the state of various animation-related variables, such as the positions of
    /// the state / key, visibility flags. It is used to reset the animation to the starting point.
    /// The `newState` parameter is included for potential state modification after the animation,
    /// but in this case, it is not utilized since the result are only hidden without further modification.
    ///
    /// - Parameters:
    ///   - newState: The modified state after the animation. This parameter is not used in this function
    ///     because the round keys simply appear without requiring changes.
    ///   - showResult: Controls whether the result is visible after resetting.
    func resetAnimationState(state newState: [[Byte]], showResult: Double) {
        withAnimation {
            positionState = Position.default2DPositions(rows: 4, cols: 4)
            positionKey = Position.default2DPositions(rows: 4, cols: 4)
            showNewState = Array.create2DArray(repeating: showResult, rows: 4, cols: 4)
            changeVisibility(value: 0.0)
        }
    }
}
