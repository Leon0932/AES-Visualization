//
//  KeyExpansionViewModel.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.08.24.
//

import Foundation
import SwiftUI

class KeyExpansionViewModel: AnimationViewModel {
    // MARK: - Properties
    let operationDetails: OperationDetails
    
    // RoundKeys as Columns
    /// `result` and `copyOfState` won't be used, because
    /// they wil be not modified during the animations, but are protocol required
    @Published var roundKeys: [[Byte]]
    let result: [[Byte]] = []
    let copyOfMatrix: [[Byte]] = []
    
    // For RotWord necessary
    @Published var positionKey: [Position] = Position.default1DPositions(count: 4)
    
    // Flags for the Animations
    @Published var showSubBytes = false
    @Published var showRCONs = 0.0
    @Published var showColumnOne = 0.0
    @Published var showColumnTwo = 0.0
    @Published var startRCONAnimation = false
    @Published var showRoundKeyColumn: [Double]
    @Published var showAnimationText = false
    @Published var showFirstXOR = 0.0
    @Published var showSecondXOR = 0.0
    @Published var showEqual = 0.0
    @Published var showResult = 0.0
    
    // Round Keys Attachment
    @Published var showKeyExpRounds = false
    @Published var keyExpRounds: [KeyExpansionRound]
    
    // Results for the calculation (XOR, RCONs, ...)
    @Published var columnOne: [Byte] = Array(repeating: 0x00, count: 4)
    @Published var columnTwo: [Byte] = Array(repeating: 0x00, count: 4)
    @Published var columnResult: [Byte] = Array(repeating: 0x00, count: 4)
    @Published var highlightColumn: [Bool]
    
    // RCONs properties
    @Published var rConstants: [[Byte]]
    @Published var highlightRCon: [Bool] = Array(repeating: false, count: 11)
    
    @Published var keySize: AESKeySize
    @Published var animationText = ""
    
    // Neccssary for the View
    let boxSize: CGFloat = 50
    let spacing: CGFloat = 10
    let nK: Int
    let arraySize: Int
    @Published var showBlockForm = false
    
    // Task und Steps Handler
    @Published var animationControl = AnimationControl()
    var animationData = AnimationData()
    
    // For SubBytes
    var resultSubBytes: [[Byte]] = []
    var substitudedByte: [[Byte]] = []
    let operationDetailsSubBytes = OperationDetails(operationName: .subBytes, isInverseMode: false, currentRound: -1)
    lazy var subBytesViewModel = {
        return SubBytesViewModel(state: self.substitudedByte,
                                 result: self.resultSubBytes,
                                 operationDetails: self.operationDetails,
                                 animationControl: animationControl)
    }()
    
    // MARK: - Initializer
    init(roundKeys: [[Byte]],
         operationDetails: OperationDetails,
         keyExpRounds: [KeyExpansionRound],
         keySize: AESKeySize) {
        // Calculating the size of the array, based on the Key Size
        arraySize = 4 * (keySize.rounds + 1)
        nK = keySize.rawValue
        
        self.roundKeys = roundKeys
        self.operationDetails = operationDetails
        self.keyExpRounds = keyExpRounds
        self.keySize = keySize
        self.substitudedByte = Array(repeating: Array(repeating: 0x00, count: 4), count: 4)
        
        self.showRoundKeyColumn = Array(repeating: 0.0, count: arraySize)
        self.highlightColumn = Array(repeating: false, count: arraySize)
        
        rConstants = AESConstants.rcon
        
        for i in 0..<nK { showRoundKeyColumn[i] = 1.0 }
    }
    
    // MARK: - Animation Steps Creation
    /// Creates the animation steps for the entire animation sequence.
    ///
    /// This function is called when the view appears, and it ensures that the `animationSteps` and `reverseAnimationSteps` arrays
    /// are filled only once. The function calculates and appends the animation steps based on the Key Expansion Algorithm
    ///
    /// - Parameter geometry: The `GeometryProxy` object used to calculate the view's layout for positioning animations.
    @MainActor
    func createAnimationSteps(with geometry: GeometryProxy) {
        // Check Empyt Array
        if animationData.animationSteps.isEmpty || animationData.reverseAnimationSteps.isEmpty {
            // Using the Key Expansion Algorithm
            for index in nK..<arraySize {
                if index % nK == 0 {
                    let roundKeyWithOps = performRoundKeyWithOperations(index: index)
                    animationData.animationSteps.append(contentsOf: roundKeyWithOps.0)
                    animationData.reverseAnimationSteps.append(contentsOf: roundKeyWithOps.1)
                    
                } else if keySize == .key256 && index % nK == 4 {
                    let subBytesAnimation = performSubBytesFor256(index: index)
                    animationData.animationSteps.append(contentsOf: subBytesAnimation.0)
                    animationData.reverseAnimationSteps.append(contentsOf: subBytesAnimation.1)
                } else {
                    let roundKeyAnimation = performRoundKey(index: index)
                    animationData.animationSteps.append(contentsOf: roundKeyAnimation.0)
                    animationData.reverseAnimationSteps.append(contentsOf: roundKeyAnimation.1)
                }
            }
            
            handleAnimationStart()
        }
    }
    
    /// Creates animation steps for performing the following operations in sequence:
    ///  - RotWord
    ///  - SubBytes
    ///  - XOR with RCON
    ///
    /// This function generates a series of `AnimationStep` objects for animating the combination of RotWord, SubBytes,
    /// and XOR with RCON operations. The reverse animation undoes these steps, restoring the original key.
    ///
    /// - Parameter index: The current index used for value assignment and column highlighting during the animation.
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///   and the second array handles the reverse animation.
    @MainActor
    func performRoundKeyWithOperations(index: Int) -> ([AnimationStep], [AnimationStep]) {
        /// Helper Steps
        let highlightRCON = [
            AnimationStep(animation: { withAnimation { self.showSecondXOR = 1.0 } }, delay: short),
            AnimationStep(animation: { withAnimation { self.showRCONs = 1.0 } }, delay: short),
            AnimationStep(animation: { withAnimation { self.highlightRCon[(index / self.nK)] = true } }, delay: short)
        ]
        
        var normalSteps = [
            AnimationStep { await self.assignValues(index: index) },
            AnimationStep(animation: {
                await self.checkDoubleAnimation()
                self.startRCONAnimation = true
            }, delay: normal),
        ]
        + highlightColumnTwo(index: index, value: 1.0)
        
        let lastSteps = highlightLeftSide(index: index)
        + highlightRCON
        + highlightRightSide(index: index, isReverse: false)
        +  [
            AnimationStep(animation: { withAnimation { self.showResult = 0.0 } }, delay: short),
            AnimationStep(animation: {
                withAnimation {
                    self.changeValues(index: index, value: 0.0)
                    self.changeRCON(index: index, value: 0.0)
                }
            }, delay: short),
        ]
        
        var reverseStartSteps = [
            AnimationStep(animation: {
                await self.checkDoubleAnimation(for: self.normal)
                self.startRCONAnimation = false
            }, delay: normal),
            AnimationStep(animation: {
                withAnimation {
                    self.highlightColumn[index - 1] = false
                    self.showColumnTwo = 0.0
                } }, delay: normal)
        ]
        
        let lastReverseSteps = [
            AnimationStep(animation: {
                withAnimation {
                    /// Reset all values, except `columnTwo`
                    self.highlightRCon[index / self.nK] = false
                    self.showRCONs = 0.0
                    self.showEqual = 0.0
                    self.highlightColumn[index - self.nK] = false
                    self.showFirstXOR = 0.0
                    self.showSecondXOR = 0.0
                    self.showColumnOne = 0.0
                }
            }, delay: short),
            AnimationStep(animation: { withAnimation { self.showResult = 0.0 } }, delay: short)
        ]
        + highlightLeftSide(index: index)
        + [
            AnimationStep(animation: {
                withAnimation {
                    self.highlightColumn[index - 1] = true
                    self.showColumnTwo = 1.0
                } }, delay: short),
        ]
        + highlightRCON
        + highlightRightSide(index: index, isReverse: true)
        + [
            AnimationStep {
                await self.assignValuesForRotSub(index: index)
                self.startRCONAnimation = true
            }
        ]
        
        let rotWordAnimation = performRotWordAnimation(index: index)
        let subBytesAnimation = performSubBytesAnimation(index: index)
        
        normalSteps.append(contentsOf:  rotWordAnimation.0 + subBytesAnimation.0 + lastSteps)
        reverseStartSteps.append(contentsOf: rotWordAnimation.1 + subBytesAnimation.1 + lastReverseSteps)
        
        return (normalSteps, reverseStartSteps)
    }
    
    /// Performs a basic XOR operation between two columns and returns the animation steps for both forward and reverse animations.
    ///
    /// This function generates a sequence of `AnimationStep` objects to animate a basic XOR operation between two columns
    /// based on the given `index`.
    /// The reverse animation restores the columns to their original key and undoes the XOR operation.
    ///
    /// - Parameter index: The current index used to retrieve values and apply the XOR operation.
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///   and the second array handles the reverse animation.
    func performRoundKey(index: Int) -> ([AnimationStep], [AnimationStep]) {
        let normalSteps = [AnimationStep { await self.assignValues(index: index) }]
        + highlightLeftSide(index: index)
        + highlightColumnTwo(index: index, value: 1.0)
        + highlightRightSide(index: index, isReverse: false)
        + setResultInvisible(index: index, isReverse: false)
        
        
        let reverseSteps = setResultInvisible(index: index, isReverse: true)
        + highlightLeftSide(index: index)
        + highlightColumnTwo(index: index, value: 1.0)
        + highlightRightSide(index: index, isReverse: true)
        + [AnimationStep { await self.assignValues(index: index) }]
        
        return (normalSteps, reverseSteps)
    }
    
    /// Creates the SubBytes operation exclusive to AES-256, including forward and reverse animations.
    ///
    /// This function generates a sequence of `AnimationStep` objects that animate the SubBytes operation
    /// specifically for AES-256. The forward animation includes assigning values and highlighting columns
    /// based on the current `index`, while the reverse animation undoes the operation, restoring the original key.
    ///
    /// - Parameter index: The current index used for assigning values and highlighting columns during the animation.
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///   and the second array handles the reverse animation.
    func performSubBytesFor256(index: Int) -> ([AnimationStep], [AnimationStep]) {
        var normalSteps = [
            AnimationStep(animation: { await self.assignValues(index: index) })
        ]
        + highlightColumnTwo(index: index, value: 1.0)
        
        let lastSteps = highlightLeftSide(index: index)
        + highlightRightSide(index: index, isReverse: false)
        + setResultInvisible(index: index, isReverse: false)
        
        var reverseSteps = highlightColumnTwo(index: index, value: 0.0)
        let lastReverseSteps = [
            AnimationStep(animation: {
                withAnimation {
                    /// `columnTwo` should be visible to maintain the animation logic
                    self.changeValues(index: index, value: 0.0)
                    self.showResult = 0.0
                    self.showColumnTwo = 1.0
                }
            }, delay: normal),
        ]
        + highlightLeftSide(index: index)
        + [
            AnimationStep(animation: {
                withAnimation {
                    self.highlightColumn[index - 1] = true
                    self.showColumnTwo = 1.0
                } }, delay: short),
        ]
        + highlightRightSide(index: index, isReverse: true)
        + [
            AnimationStep { await self.assignValuesForRotSub(index: index) }
        ]
        
        let subBytesSteps = performSubBytesAnimation(index: index)
        
        normalSteps.append(contentsOf: subBytesSteps.0 + lastSteps)
        reverseSteps.append(contentsOf: subBytesSteps.1 + lastReverseSteps)
        
        return (normalSteps, reverseSteps)
    }
    
    /// Creates animation steps for the RotWord operation, both forward and reverse animations.
    ///
    /// This function generates a sequence of `AnimationStep` objects that animate the RotWord operation
    /// on a set of cells. The forward animation rotates the cells to the left, while the reverse animation
    /// restores the cells to their original positions.
    ///
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///   and the second array handles the reverse animation.
    func performRotWordAnimation(index: Int) -> ([AnimationStep], [AnimationStep]) {
        let shiftRowsHelper = ShiftRowsHelper(boxSize: boxSize, spacing: spacing)
        
        var normalSteps = [
            AnimationStep(animation: {
                // Cell will be animated to left middle under
                withAnimation {
                    self.positionKey[0].x = -shiftRowsHelper.middleOffset
                    self.positionKey[0].y = 100
                }
            }, delay: normal),
            AnimationStep(animation: {
                // Three other cells will be rotated left
                withAnimation {
                    for i in 1...3 { self.positionKey[i].y = -shiftRowsHelper.boxSizeWithSpacing }
                }
            }, delay: normal),
            AnimationStep {
                // Cell will be set to the end
                withAnimation {
                    self.positionKey[0].y = shiftRowsHelper.returnOffset
                    self.positionKey[0].x = 0
                }
            },
            AnimationStep(animation: {
                // Perform Rot Word
                await self.sleep(for: self.normal)
                self.columnTwo = self.keyExpRounds[index - self.nK].afterRotWord
                self.positionKey = Position.default1DPositions(count: 4)
            }, delay: short),
        ]
        
        var reverseSteps = [
            AnimationStep(animation: {
                // Reverse Rot Word Animation
                await self.sleep(for: self.normal)
                // self.columnTwo = self.aesKey.rotWord(self.columnTwo, isInverse: true)
                self.columnTwo = self.keyExpRounds[index - self.nK].temp
                self.positionKey = Position.default1DPositions(count: 4)
            }, delay: normal),
            AnimationStep(animation: {
                withAnimation {
                    // If the first cell is still in the air,
                    // only the cell should be reset,
                    // meaning it should return to its original position.
                    if self.positionKey[0].x == -shiftRowsHelper.middleOffset {
                        for i in 1...3 { self.positionKey[i].y = 0 }
                        
                        self.positionKey[0].x = 0
                        self.positionKey[0].y = 0
                        return
                    }
                    
                    // Otherwise, continue executing the RotWord reverse animation.
                    self.positionKey[3].x = 0
                    self.positionKey[3].y = -shiftRowsHelper.returnOffset
                }
            }, delay: normal),
            AnimationStep(animation: {
                withAnimation {
                    // If the second cell is moved upwards, then reset the cells
                    if self.positionKey[1].y == -shiftRowsHelper.boxSizeWithSpacing {
                        for i in 1...3 { self.positionKey[i].y = 0 }
                    } else {
                        // Move the cells updown
                        for i in 0...2 { self.positionKey[i].y = shiftRowsHelper.boxSizeWithSpacing }
                    }
                }
            }, delay: normal),
            AnimationStep(animation: {
                withAnimation {
                    // If the first cell is not in the position after RotWord,
                    // the RotWord animation should be started in reverse.
                    if self.positionKey[0].y != shiftRowsHelper.returnOffset || self.positionKey[0].x != 0 {
                        self.positionKey[3].y = -100
                        self.positionKey[3].x = -shiftRowsHelper.middleOffset
                    } else {
                        // Reset
                        self.positionKey[0].y = 0
                        self.positionKey[0].x = 0
                    }
                }
            }, delay: normal),
        ]
        
        addAnimationOperationText(operation: "RotWord",
                                  normalSteps: &normalSteps,
                                  reverseSteps: &reverseSteps)
        
        return (normalSteps, reverseSteps)
    }
    
    /// Creates animation steps for performing the SubBytes operation.
    ///
    /// This function generates a sequence of `AnimationStep` objects that animate the SubBytes operation,
    /// including both forward and reverse animations. The forward animation applies the SubBytes transformation
    /// to the data in `columnTwo`, while the reverse animation undoes the transformation. The animation steps
    /// also include the display of the SubBytes operation view.
    ///
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///   and the second array handles the reverse animation.
    func performSubBytesAnimation(index: Int) -> ([AnimationStep], [AnimationStep]) {
        var normalSteps = [
            AnimationStep {
                self.subBytesViewModel.animationControl = self.animationControl
                self.substitudedByte = self.columnTwo.map { [$0] }
                self.resultSubBytes = self.keyExpRounds[index - self.nK].afterSubWord.map { [$0] }
                self.subBytesViewModel = SubBytesViewModel(state: self.substitudedByte,
                                                           result: self.resultSubBytes,
                                                           operationDetails: self.operationDetailsSubBytes,
                                                           animationControl: self.animationControl)
            },
            AnimationStep { withAnimation { self.showSubBytes = true } },
            AnimationStep { await self.checkIfSubBytesIsDone() },
        ]
        
        var reverseSteps = [
            AnimationStep { await self.checkIfSubBytesIsDone() },
            AnimationStep(animation: {
                withAnimation {
                    self.showSubBytes = true
                    self.subBytesViewModel.animationControl = self.animationControl
                    self.subBytesViewModel.animationControl.isBackward = true
                }
            }, delay: short),
            AnimationStep(animation: {
                self.subBytesViewModel = SubBytesViewModel(state: self.substitudedByte,
                                                           result: self.resultSubBytes,
                                                           operationDetails: self.operationDetailsSubBytes,
                                                           animationControl: self.animationControl)
                self.subBytesViewModel.completeAnimations()
                
            }, delay: normal),
        ]
        
        addAnimationOperationText(operation: "SubBytes",
                                  normalSteps: &normalSteps,
                                  reverseSteps: &reverseSteps)
        
        return (normalSteps, reverseSteps)
        
    }
    
    // MARK: - Animation Steps Creation Helper Functions
    /// Creates a sequence of animation steps to highlight the second column based on the given index and visibility value.
    ///
    /// This function generates an array of `AnimationStep` objects to control the highlighting and visibility of
    /// the second column (`columnTwo`). The visibility is adjusted based on the provided `value`, where `1.0`
    /// shows the column, and any other value hides it.
    ///
    /// - Parameters:
    ///   - index: The index used to determine which part of `columnTwo` to highlight.
    ///   - value: The visibility value. A value of `1.0` makes the column visible, and any other value hides it.
    /// - Returns: An array of `AnimationStep` objects that control the highlighting and visibility of `columnTwo`.
    private func highlightColumnTwo(index: Int, value: Double) -> [AnimationStep] {
        return [
            AnimationStep(animation: { withAnimation { self.highlightColumn[index - 1] = value != 0.0 } }, delay: short),
            AnimationStep(animation: { withAnimation { self.showColumnTwo = value } }, delay: short),
        ]
    }
    
    /// Creates a sequence of animation steps to highlight the left-side elements during the animation.
    ///
    /// This function generates an array of `AnimationStep` objects that highlight specific left-side elements,
    /// such as a column and the XOR operation, based on the provided `index`.
    ///
    /// - Parameter index: The index used to determine which column to highlight and apply visibility changes to.
    /// - Returns: An array of `AnimationStep` objects to control the highlighting and visibility of left-side elements during the animation.
    private func highlightLeftSide(index: Int) -> [AnimationStep] {
        return [
            AnimationStep(animation: { withAnimation { self.highlightColumn[index - self.nK] = true } }, delay: normal),
            AnimationStep(animation: { withAnimation { self.showColumnOne = 1.0 } }, delay: short),
            AnimationStep(animation: { withAnimation { self.showFirstXOR = 1.0 } }, delay: short)
        ]
    }
    
    /// Creates a sequence of animation steps to highlight the right side elements during the animation.
    ///
    /// This function generates an array of `AnimationStep` objects that highlight various right-side elements,
    /// such as the equality symbol, the result, and the round key column. The visibility of these elements is
    /// controlled based on the provided `index` and whether the animation is running in reverse.
    ///
    /// - Parameters:
    ///   - index: The index used to determine which round key column to highlight.
    ///   - isReverse: A Boolean indicating whether the animation should reverse the visibility changes. If `true`, the highlighted element will be hidden.
    /// - Returns: An array of `AnimationStep` objects to control the visibility of the right-side elements during the animation.
    private func highlightRightSide(index: Int, isReverse: Bool) -> [AnimationStep] {
        return [
            AnimationStep(animation: { withAnimation { self.showEqual = 1.0 } }, delay: short),
            AnimationStep(animation: { withAnimation { self.showResult = 1.0 } }, delay: normal),
            AnimationStep(animation: { withAnimation { self.showRoundKeyColumn[index] = isReverse ? 0.0 : 1.0 } }, delay: short),
        ]
    }
    
    /// Creates a sequence of animation steps to make the result and related values invisible.
    ///
    /// This function generates a series of `AnimationStep` objects to hide the result at the given `index`
    /// and optionally include a step to hide the result visibility itself, depending on whether the animation
    /// is in reverse order. The steps control the visibility of the result and associated values during the animation.
    ///
    /// - Parameters:
    ///   - index: The index used to determine which values to hide.
    ///   - isReverse: A Boolean flag indicating whether the animation is in reverse order. If `true`, the steps will be arranged accordingly.
    /// - Returns: An array of `AnimationStep` objects that control the visibility of the result and related values.
    private func setResultInvisible(index: Int, isReverse: Bool) -> [AnimationStep] {
        let showResultStep = AnimationStep(animation: { withAnimation { self.showResult = 0.0 } }, delay: short)
        var steps = [
            AnimationStep(animation: { withAnimation { self.changeValues(index: index, value: 0.0) } }, delay: short)
        ]
        
        steps.insert(showResultStep, at: isReverse ? 1 : 0)
        
        return steps
    }
    
    /// Adds animation steps to show and hide the operation text during an animation sequence.
    ///
    /// This function inserts steps to display the provided `operation` text at the start of the animation
    /// and hide it afterward. It also adds the corresponding reverse steps to undo the text display.
    /// The `normalSteps` sequence will show the text, while the `reverseSteps` will hide it in reverse order.
    ///
    /// - Parameters:
    ///   - operation: The text representing the operation to display during the animation.
    ///   - normalSteps: An array of `AnimationStep` objects that will display and then hide the text in a normal sequence.
    ///   - reverseSteps: An array of `AnimationStep` objects that will perform the reverse sequence, hiding and then showing the text.
    private func addAnimationOperationText(operation: String,
                                           normalSteps: inout [AnimationStep],
                                           reverseSteps: inout [AnimationStep]) {
        let showTextStep = AnimationStep(animation: { self.changeAnimationText(value: (operation, true)) }, delay: normal)
        let invisbleTextStep = AnimationStep(animation: { self.changeAnimationText(value: ("", false)) }, delay: normal)
        
        normalSteps.insert(showTextStep, at: 0)
        normalSteps.append(invisbleTextStep)
        
        reverseSteps.insert(invisbleTextStep, at: 0)
        reverseSteps.append(showTextStep)
    }
    
    // MARK: - Modifier Helper Functions
    /// Check if the SubBytes animation is done.
    ///
    /// This function checks whether the SubBytes animation is finished. Once the animation is complete,
    /// the values are assigned to `columnTwo`, and the `SubBytesAnimationView` disappears.
    @MainActor
    private func checkIfSubBytesIsDone() async {
        repeat {
            await sleep(for: short)
        } while !subBytesViewModel.animationControl.isDone
        
        assignColumTwoFromSub()
        
        await sleep(for: short)
        
        withAnimation { showSubBytes = false }
        
        await sleep(for: normal)
    }
    
    /// Assigns values to columns based on the current round key and the given index.
    ///
    /// This function updates `columnOne`, `columnTwo`, and `columnResult` based on the current round key
    /// and the provided `index`. It also ensures that any ongoing double animations are checked before
    /// assigning the values for a smooth visual transition.
    ///
    /// - Parameter index: The current index used to retrieve values from the key array.
    @MainActor
    private func assignValues(index: Int) async {
        await checkDoubleAnimation()
        columnOne = roundKeys[index - nK]
        columnTwo = roundKeys[index - 1]
        columnResult = roundKeys[index]
    }
    
    /// Assigns values to columns based on the current round key and the given index.
    ///
    /// This function processes the columns by first applying the RotWord operation to `columnTwo`,
    /// followed by the SubBytes transformation. The resulting values are then updated in the appropriate
    /// columns. The function also checks for double animations to ensure smooth visual transitions.
    ///
    /// - Parameter index: The current index used to fetch values from the key array and apply transformations.
    @MainActor
    private func assignValuesForRotSub(index: Int) async {
        // For `isDouble` and clean animations
        await checkDoubleAnimation()
        
        columnOne = roundKeys[index - nK]
        columnTwo = keyExpRounds[index - nK].afterSubWord
        columnResult = roundKeys[index]
        
        substitudedByte = keyExpRounds[index - nK].afterRotWord.map { [$0] }
        resultSubBytes = columnTwo.map { [$0] }
    }
    
    /// Assigns values to `columnTwo` using data from the `SubBytesViewModel`.
    ///
    /// This function updates the values of `columnTwo` by copying the first column of the `state` array
    /// from the `SubBytesViewModel`.
    func assignColumTwoFromSub() {
        withAnimation {
            for i in 0..<columnTwo.count {
                columnTwo[i] = subBytesViewModel.state[i][0]
            }
        }
    }
    
    /// Updates the visibility of flags and columns based on the given index and visibility value.
    ///
    /// This function adjusts the visibility of specific columns and highlights them based on the
    /// provided `value`. If `value` equals 1.0, the columns will appear in the view, otherwise
    /// they will disappear.
    ///
    /// - Parameters:
    ///   - index: The current index to determine which columns to modify.
    ///   - value: A value controlling the visibility. Set to `1.0` to make the columns visible, or any other value to hide them.
    private func changeValues(index: Int, value: Double) {
        changeVisibility(value: value)
        highlightColumn[index - nK] = value != 0.0
        highlightColumn[index - 1] = value != 0.0
    }
    
    /// Adjusts the visibility of RCON flags and related variables based on the given index and visibility value.
    ///
    /// This function modifies the visibility of RCON flags, controls the display of RCON elements,
    /// and triggers the RCON animation based on the provided `value`. If `value` is 1.0, the elements will appear,
    /// otherwise, they will disappear.
    ///
    /// - Parameters:
    ///   - index: The current index used to determine which RCON flag to modify.
    ///   - value: A value controlling visibility. Set to `1.0` to make the RCON elements visible, or any other value to hide them.
    private func changeRCON(index: Int, value: Double) {
        highlightRCon[index / nK] = value != 0.0
        showRCONs = value
        startRCONAnimation = value != 0.0
    }
    
    /// Adjusts the visibility of various flags and columns based on the provided visibility value.
    ///
    /// This function controls the visibility of multiple flags and columns in the view.
    /// If `value` is set to 1.0, the flags and columns will appear; otherwise, they will disappear.
    ///
    /// - Parameter value: A value controlling visibility. Set to `1.0` to make the elements visible, or any other value to hide them.
    private func changeVisibility(value: Double) {
        showFirstXOR = value
        showSecondXOR = value
        
        showColumnOne = value
        showColumnTwo = value
        
        showEqual = value
    }
    
    /// Updates the animation text and its visibility (e.g., for RotWord or SubBytes animations).
    ///
    /// This function changes the displayed animation text and controls whether the text is visible.
    /// The visibility and text content are updated together.
    ///
    /// - Parameter value: A tuple where the first element is the new text to display, and the second element is a boolean
    /// indicating whether the text should be visible (`true` for visible, `false` for hidden).
    private func changeAnimationText(value: (String, Bool)) {
        withAnimation {
            showAnimationText = value.1
            animationText = value.0
        }
    }
    // MARK: - Animation Control
    /// Resets all variables related to the animation to their initial key.
    ///
    /// This function reinitializes the key of various animation-related variables, such as the positions of
    /// the round keys, visibility flags, and highlighted columns. It is used to reset the animation to the
    /// starting point. The `newState` parameter is included for potential key modification after the animation,
    /// but in this case, it is not utilized since the round keys are only hidden without further modification.
    ///
    /// - Parameters:
    ///   - newState: The modified key after the animation. This parameter is not used in this function
    ///     because the round keys simply appear without requiring changes.
    ///   - showResult: Controls whether the round keys are visible after resetting.
    func resetAnimationState(state newState: [[Byte]], showResult: Double) {
        withAnimation {
            positionKey = Position.default1DPositions(count: 4)
            showRoundKeyColumn = Array.create1DArray(repeating: showResult, count: arraySize)
            for i in 0..<nK { showRoundKeyColumn[i] = 1.0 }
            
            showSubBytes = false
            showRCONs = 0.0
            
            startRCONAnimation = false
            showAnimationText = false
            
            changeVisibility(value: 0.0)
            self.showResult = 0.0
            
            columnOne = Array(repeating: 0x00, count: 4)
            columnTwo = Array(repeating: 0x00, count: 4)
            columnResult = Array(repeating: 0x00, count: 4)
            highlightColumn = Array(repeating: false, count: arraySize)
            highlightRCon = Array(repeating: false, count: 11)
        }
    }
    
    // MARK: - Toggle Functions
    func toggleKeyExpRounds() {
        showKeyExpRounds.toggle()
    }
}
