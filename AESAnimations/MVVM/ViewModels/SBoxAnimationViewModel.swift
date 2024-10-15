//
//  SBoxAnimationViewModel.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 15.10.24.
//

import SwiftUI

class SBoxAnimationViewModel: AnimationViewModel {
    // MARK: - Properties
    var operationDetails: OperationDetails
    var result: [[Byte]] = []
    var copyOfMatrix: [[Byte]] = []
    
    @Published var opacityOfSBox: [[Double]] = Array.create2DArray(repeating: 0.0, rows: 16, cols: 16)
    
    @Published var currentByte: Byte = 0x00
    @Published var currentMultInv: Byte = 0x00
    
    @Published var showTitleOfAff: Double = 0.0
    @Published var showCurrentByte: Double = 0.0
    @Published var showCurrentMultInv: Double = 0.0
    @Published var showFirstShift: Double = 0.0
    @Published var showSecondShift: Double = 0.0
    @Published var showThirdShift: Double = 0.0
    @Published var showLastShift: Double = 0.0
    @Published var showResult: Double = 0.0
    
    @Published var firstShift: [Int] = []
    @Published var secondShift: [Int] = []
    @Published var thirdShift: [Int] = []
    @Published var lastShift: [Int] = []
 
    @Published var animationControl = AnimationControl()
    var animationTask: Task<Void, Never>? = nil
    var animationSteps: [AnimationStep] = []
    var reverseAnimationSteps: [AnimationStep] = []
    
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
        
    }
    
    // MARK: - Animation Control
    /// Resets all variables related to the animation to their initial values.
    ///
    /// This function reinitializes the values of various animation-related variables, such as the ball positions, round number, current state and
    /// current round Key . It is used to reset the animation to the starting point. The `newState` parameter is included for potential  modification after the animation,
    /// but in this case, it is not utilized.
    ///
    /// - Parameters:
    ///   - newState: The modified key after the animation. This parameter is not used in this function.
    ///   - showResult: Controls whether the result is visible after resetting.
    func resetAnimationState(state newState: [[Byte]], showResult: Double) {
        
    }
    
    
}
