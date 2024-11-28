//
//  MixColumnAnimationViewModel.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 17.08.24.
//

import SwiftUI

class MixColumnsViewModel: AnimationViewModel {
    // MARK: - Properties
    let operationDetails: OperationDetails
    
    @Published var state: [[Byte]]
    let result: [[Byte]]
    let copyOfMatrix: [[Byte]]
    
    // Additional properties
    @Published var columnPositions: [Position] = Position.default1DPositions(count: 4)
    
    @Published var isShowingMultiplication: Double = 0
    @Published var isShowingEquality: Double = 0
    @Published var isShowingResult: Double = 0
    
    @Published var showNewState: [Double] = Array(repeating: 0.0, count: 4)
    @Published var resultOfMixColumn: [Byte] = Array(repeating: 0x00, count: 4)
     
    @Published var animationControl = AnimationControl()
    var animationData = AnimationData()
    
    let boxSize: CGFloat = 50.0
    var transformationMatrix: [[Byte]]
    
    // MARK: - Initializer
    init(state: [[Byte]], result: [[Byte]], operationDetails: OperationDetails) {
        self.state = state
        self.result = result
        self.operationDetails = operationDetails
        self.transformationMatrix = operationDetails.isInverseMode ? AESConstants.invMixColumnMatrix : AESConstants.mixColumnMatrix
        
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
        
        for index in 0..<4 {
            let animations = animateColumnTransformation(width: width, index: index)
            animationData.animationSteps.append(contentsOf: animations.0)
            animationData.reverseAnimationSteps.append(contentsOf: animations.1)
        }
        
        handleAnimationStart()
    }
    
    /// Animates the transformation of a column in the state, including both forward and reverse animation sequences.
    ///
    /// This function generates a sequence of animation steps to visually represent the transformation of a column,
    /// such as during a mix column operation in AES. The animations handle the movement of the column,
    /// displaying the results of the operation, and resetting the visibility of elements.
    ///
    /// - Parameters:
    ///   - width: The width of the animation view, used to calculate the column's position during the animation.
    ///   - index: The index of the column being animated.
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///            and the second array handles the reverse animation.
    @MainActor
    private func animateColumnTransformation(width: CGFloat, index: Int) -> ([AnimationStep], [AnimationStep]) {
        let widthColumn = width * 0.515 - CGFloat(index * 60)
        
        let normalSteps: [AnimationStep] = [
            AnimationStep { for i in 0..<4 { self.resultOfMixColumn[i] = self.result[i][index] } },
            AnimationStep(animation: { await self.changePosition(col: index, y: -305) }, delay: short),
            AnimationStep(animation: { withAnimation { self.isShowingMultiplication = 1 } }, delay: short),
            AnimationStep(animation: { withAnimation { self.columnPositions[index].x = widthColumn } }, delay: short),
            AnimationStep(animation: { withAnimation { self.isShowingEquality = 1 } }, delay: short),
            AnimationStep(animation: { withAnimation { self.isShowingResult = 1 } }, delay: short),
            AnimationStep(animation: { withAnimation { self.showNewState[index] = 1 } }, delay: short),
            AnimationStep(animation: { self.resetVisibility() }, delay: short),
            AnimationStep(animation: { await self.changePosition(col: index, x: 0) }, delay: short),
            AnimationStep(animation: { withAnimation { self.columnPositions[index].y = 0 } }, delay: normal),
        ]
        
        let reverseSteps: [AnimationStep] = [
            AnimationStep(animation: { withAnimation { self.columnPositions[index].y = 0 } }, delay: short),
            AnimationStep(animation: { withAnimation { self.isShowingMultiplication = 0 } }, delay: short),
            AnimationStep(animation: { await self.changePosition(col: index, x: 0) }, delay: short),
            AnimationStep(animation: { withAnimation { self.isShowingEquality = 0 } }, delay: short),
            AnimationStep(animation: { withAnimation { self.isShowingResult = 0 } }, delay: short),
            AnimationStep(animation: { withAnimation { self.isShowingMultiplication = 1 } }, delay: short),
            AnimationStep(animation: {
                withAnimation {
                    self.columnPositions[index].x = widthColumn
                    self.columnPositions[index].y = -305
                }
            }, delay: short),
            AnimationStep(animation: { withAnimation { self.isShowingEquality = 1 } }, delay: short),
            AnimationStep(animation: {
                withAnimation {
                    self.showNewState[index] = 0
                    self.isShowingResult = 1
                }
            }, delay: normal),
            AnimationStep { for i in 0..<4 { self.resultOfMixColumn[i] = self.result[i][index] } }
        ]
        
        return (normalSteps, reverseSteps)
    }
    
    // MARK: - Modifier Helper Functions
    /// Resets the visibility of the flags
    private func resetVisibility() {
        withAnimation {
            isShowingResult = 0
            isShowingEquality = 0
            isShowingMultiplication = 0
        }
    }
    
    /// Updates the position of a column in the state.
    ///
    /// This function adjusts the x and/or y position of the specified column. If either the x or y coordinate is provided,
    /// the corresponding position is updated, and the change is animated.
    ///
    /// - Parameters:
    ///   - col: The index of the column whose position is being updated.
    ///   - x: An optional `CGFloat` representing the new x-coordinate of the column. If nil, the x position is not changed.
    ///   - y: An optional `CGFloat` representing the new y-coordinate of the column. If nil, the y position is not changed.
    @MainActor
    private func changePosition(col: Int, x: CGFloat? = nil, y: CGFloat? = nil) async {
        withAnimation {
            if let x = x {
                columnPositions[col].x = x
            }

            if let y = y {
                columnPositions[col].y = y
            }
        }
        
        await checkDoubleAnimation()
    }
    
    // MARK: - Animation Control
    /// Resets all variables related to the animation to their initial state.
    ///
    /// This function reinitializes the state of various animation-related variables, such as the positions of
    /// the state, visibility flags. It is used to reset the animation to the starting point.
    /// The `newState` parameter is included for potential state modification after the animation,
    /// but in this case, it is not utilized since the result are only hidden without further modification.
    ///
    /// - Parameters:
    ///   - newState: The modified state after the animation. This parameter is not used in this function
    ///     because the result simply appear without requiring changes.
    ///   - showResult: Controls whether the result is visible after resetting.
    func resetAnimationState(state newState: [[Byte]], showResult: Double) {
        resetVisibility()
        withAnimation {
            columnPositions = Position.default1DPositions(count: 4)
            showNewState = Array(repeating: showResult, count: 4)
            resultOfMixColumn = Array(repeating: 0x00, count: 4)
        }
    }
}
