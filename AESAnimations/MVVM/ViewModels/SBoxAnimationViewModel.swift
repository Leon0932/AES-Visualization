//
//  SBoxAnimationViewModel.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 15.10.24.
//

import SwiftUI

final class SBoxAnimationViewModel: AnimationViewModel {
    // MARK: - Properties
    var operationDetails: OperationDetails
    var result: [[Byte]] = []
    var copyOfMatrix: [[Byte]] = []
    
    var sBoxHistory: [SBoxRound] { AESMath.shared.getSBoxHistory }
    
    @Published var opacityOfSBox: [[Double]] = Array.create2DArray(repeating: 0.0, rows: 16, cols: 16)
    
    @Published var currentByte: Byte = 0x00
    @Published var currentMultInv: Byte = 0x00
    @Published var resultSBox: Byte = 0x00
    @Published var indexOfSBox: Byte = 0x00
    
    @Published var showTitleOfAff: Double = 0.0
    @Published var showCurrentByte: Double = 0.0
    @Published var showCurrentMultInv: Double = 0.0
    @Published var showResultSBox: Double = 0.0
    @Published var showIndexOfSBox: Double = 0.0
    
    @Published var showValues: [Double] = Array.create1DArray(repeating: 0.0, count: 7)
    @Published var showOperators: [Double] = Array.create1DArray(repeating: 0.0, count: 6)
    @Published var values: [[Int]] = Array.create2DArray(repeating: 0, rows: 7, cols: 8)
    
    @Published var animationControl = AnimationControl()
    var animationData = AnimationData()
    
    // MARK: - Initializer
    init(operationDetails: OperationDetails) {
        self.operationDetails = operationDetails
        
    }
    
    // MARK: - Animation Steps Creation
    /// Creates the animation steps for the entire animation sequence.
    ///
    /// This function is called when the view appears, and it ensures that the `animationSteps` and `reverseAnimationSteps` arrays
    /// are filled only once. The function calculates and appends the animation steps based on the Rjindael-Algorithm
    ///
    /// - Parameter geometry: The `GeometryProxy` object used to calculate the view's layout for positioning animations.
    func createAnimationSteps(with geometry: GeometryProxy) {
        for index in 0..<256 {
            let start = kickOfAnimation(index: index)
            let affineCalc = createAffineCalculation(index: index)
            let end = endAnimation(index: index)
            
            let steps = start.0 + affineCalc.0 + end.0
            let reverse = start.1 + affineCalc.1 + end.1
            
            animationData.animationSteps.append(contentsOf: steps)
            animationData.reverseAnimationSteps.append(contentsOf: reverse)
        }
        
        handleAnimationStart()
    }
    
    // MARK: - Animation Steps Creation Helper Functions
    
    /// Initializes and returns the animation steps for both forward and reverse animations.
    ///
    /// This function prepares and returns the steps required to kick off the animation sequence.
    /// It begins by displaying the current byte, followed by its multiplicative inverse, and
    /// concludes with the title of the affine transformation. The animation proceeds in two directions:
    /// a forward animation to display elements, and a reverse animation to hide them.
    ///
    /// - Parameters:
    ///   - index: The index used to determine which values to hide.
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///   and the second array handles the reverse animation.
    func kickOfAnimation(index: Int) -> ([AnimationStep], [AnimationStep]) {
        let normalSteps = [
            AnimationStep(animation: {
                await self.checkAnimationSpeed()
                withAnimation { self.currentByte = Byte(index) }
            },
                          delay: short),
            
            AnimationStep(animation: { withAnimation { self.showCurrentByte = 1.0 } },
                          delay: short),
            
            AnimationStep(animation: {
                await self.checkAnimationSpeed()
                withAnimation { self.currentMultInv = self.sBoxHistory[index].multInv }
            },
                          delay: short),
            
            AnimationStep(animation: { withAnimation { self.showCurrentMultInv = 1.0 } },
                          delay: short),
            
            AnimationStep(animation: { withAnimation { self.showTitleOfAff = 1.0 } },
                          delay: normal)
        ]
        
        let reverseSteps = [
            AnimationStep(animation: { withAnimation { self.showCurrentByte = 0.0 } },
                          delay: short),
            
            AnimationStep(animation: { withAnimation { self.showCurrentMultInv = 0.0 } },
                          delay: short),
            
            AnimationStep(animation: { withAnimation { self.showTitleOfAff = 0.0 } },
                          delay: normal)
        ]
        
        return (normalSteps, reverseSteps)
    }
    
    
    /// Creates and returns the animation steps for the affine transformation calculation.
    ///
    /// This function generates the animation sequence that visually represents the affine transformation
    /// calculation. The calculation involves displaying values and operators step by step, with corresponding
    /// forward and reverse animations. The forward animation reveals the values and operators, while
    /// the reverse animation hides them in reverse order.
    ///
    /// - Parameters:
    ///   - index: The index used to determine which values to hide.
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///   and the second array handles the reverse animation.
    func createAffineCalculation(index: Int) -> ([AnimationStep], [AnimationStep]) {
        var normalSteps: [AnimationStep] = []
        var reverseSteps: [AnimationStep] = []
        let valuesOfRound = getValuesOfRound(index: index)
        
        for i in 0..<values.count {
            normalSteps.append(contentsOf: [
                AnimationStep(animation: {
                    await self.checkAnimationSpeed()
                    withAnimation { self.values[i] = valuesOfRound[i] }
                },
                              delay: normal),
                
                AnimationStep(animation: { withAnimation { self.showValues[i] = 1.0 } },
                              delay: short),
            ])
            
            reverseSteps.append(
                AnimationStep(animation: { withAnimation { self.showValues[i] = 0.0 } },
                              delay: short)
            )
            
            if i != 6 {
                normalSteps.append(AnimationStep(animation: { withAnimation { self.showOperators[i] = 1.0 } },
                                                 delay: i == 6 ? normal : short))
                reverseSteps.append(AnimationStep(animation: { withAnimation { self.showOperators[i] = 0.0 } },
                                                  delay: i == 6 ? normal : short))
            }
            
            
        }
        
        return (normalSteps, reverseSteps)
    }
    
    /// Creates and returns the animation steps for concluding the current animation sequence.
    ///
    /// This function finalizes the animation by displaying the result of the S-box operation and
    /// updating the corresponding UI elements. The function generates both the forward and reverse
    /// animation sequences. The forward animation reveals the result of the S-box operation, while
    /// the reverse animation hides the result and sets the UI components to their initial state.
    ///
    /// - Parameters:
    ///   - index: The index used to determine which values to hide.
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///   and the second array handles the reverse animation.
    func endAnimation(index: Int) -> ([AnimationStep], [AnimationStep]) {
        let normalSteps = [
            AnimationStep(animation: {
                await self.checkAnimationSpeed()
                withAnimation {
                    self.resultSBox = self.sBoxHistory[index].result
                    self.indexOfSBox = Byte(index)
                }
            },
                          delay: normal),
            
            AnimationStep(animation: {
                withAnimation {
                    self.showResultSBox = 1.0
                    self.showIndexOfSBox = 1.0
                }
            },
                          delay: normal),
            
            AnimationStep(animation: {
                withAnimation {
                    if self.operationDetails.isInverseMode {
                        let row = Int(self.resultSBox) / 16
                        let col = Int(self.resultSBox) % 16
                        self.opacityOfSBox[row][col] = 1.0
                    } else {
                        let row = index / 16
                        let col = index % 16
                        self.opacityOfSBox[row][col] = 1.0
                    }
                }
            },
                          delay: short),
            
            AnimationStep(animation: { withAnimation { self.changeValues() } },
                          delay: normal),
        ]
        
        var reverseSteps = [
            AnimationStep(animation: {
                withAnimation {
                    self.showResultSBox = 0.0
                    self.showIndexOfSBox = 0.0
                }
            },
                          delay: normal),
            
            AnimationStep(animation: {
                withAnimation {
                    if self.operationDetails.isInverseMode {
                        let row = Int(self.resultSBox) / 16
                        let col = Int(self.resultSBox) % 16
                        self.opacityOfSBox[row][col] = 0.0
                    } else {
                        let row = index / 16
                        let col = index % 16
                        self.opacityOfSBox[row][col] = 0.0
                    }
                }
            },
                          delay: short),
            
            AnimationStep(animation: {
                await self.checkAnimationSpeed()
                withAnimation { self.changeValues(value: 1.0) } },
                          delay: normal)
        ]
        
        let valuesOfRound = getValuesOfRound(index: index)
        for i in 0..<values.count {
            reverseSteps.append(
                AnimationStep { withAnimation { self.values[i] = valuesOfRound[i] } }
            )
        }
        
        reverseSteps += [
            AnimationStep { withAnimation { self.currentByte = Byte(index) } },
            AnimationStep { withAnimation { self.currentMultInv = self.sBoxHistory[index].multInv } },
            AnimationStep {
                withAnimation {
                    self.indexOfSBox = Byte(index)
                    self.resultSBox = self.sBoxHistory[index].result
                }
            }
        ]
        
        return (normalSteps, reverseSteps)
    }
    
    // MARK: - Helper Functions
    /// Resets or updates the visibility values for various UI components involved in the animation.
    ///
    /// This function changes the visibility of several animation-related UI components, such as values,
    /// operators, and S-box results. It updates these components to the specified `value`, which is useful
    /// for resetting the animation or changing visibility states.
    ///
    /// - Parameter value: A `Double` value that determines the visibility of the components. The default
    ///   value is `0.0`, which hides the components. `1.0` to make them visible.
    func changeValues(value: Double = 0.0) {
        showValues = Array.create1DArray(repeating: value, count: 7)
        showOperators = Array.create1DArray(repeating: value, count: 7)
        showResultSBox = value
        showCurrentByte = value
        showTitleOfAff = value
        showCurrentMultInv = value
        showIndexOfSBox = value
    }
    
    
    /// Retrieves the binary values related to the S-box transformations for a specific round.
    ///
    /// This function returns a collection of binary values associated with the S-box transformations
    /// for the specified round. These values include the multiplicative inverse, various shift transformations,
    /// and the final result of the affine transformation.
    ///
    /// - Parameter index: The index of the round in the `sBoxHistory` array from which the binary values
    ///   are retrieved.
    ///
    /// - Returns: A 2D array of `Int` values representing different stages of the S-box transformation for
    ///   the given round.
    func getValuesOfRound(index: Int) -> [[Int]] {
        let roundSBox = sBoxHistory[index]
        return [roundSBox.multInvBinar,
                roundSBox.firstShift,
                roundSBox.secondShift,
                roundSBox.thirdShift,
                roundSBox.fourthShift,
                AESConstants.affineConstBinary,
                roundSBox.resultBinar]
    }
    
    // MARK: - Animation Control
    /// Resets all variables related to the animation to their initial values.
    ///
    /// This function reinitializes the values of various animation-related variables. The `newState` parameter is included for potential
    /// modification after the animation, but in this case, it is not utilized.
    ///
    /// - Parameters:
    ///   - newState: The modified key after the animation. This parameter is not used in this function.
    ///   - showResult: Controls whether the result is visible after resetting.
    func resetAnimationState(state newState: [[Byte]], showResult: Double) {
        withAnimation {
            changeValues()
            opacityOfSBox = Array.create2DArray(repeating: showResult, rows: 16, cols: 16)
        }
    }
}
