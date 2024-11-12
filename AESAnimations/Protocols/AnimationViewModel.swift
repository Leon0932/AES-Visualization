//
//  AnimationViewModelv2.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 12.09.24.
//

import SwiftUI

protocol AnimationViewModel: ObservableObject {
    /// View Variables
    var operationDetails: OperationDetails { get }
    var result: [[Byte]] { get }
    var copyOfMatrix: [[Byte]] { get }
    
    /// Animation Controllers
    var animationControl: AnimationControl { get set }
    var animationData: AnimationData { get set }
    
    @MainActor
    func createAnimationSteps(with geometry: GeometryProxy)
    func resetAnimationState(state newState: [[Byte]], showResult: Double)
    
}

extension AnimationViewModel {
    // Standard values for the animation duration
    /// 1 second
    var normal: UInt64 { return 1_000_000_000 }
    
    /// 0.5 seconds
    var short: UInt64 { return 500_000_000 }
    
    /// Pauses the animation for the specified duration.
    /// - Parameter nanoseconds: The amount of time to pause the animation, in nanoseconds.
    func sleep(for nanoseconds: UInt64) async {
        try? await Task.sleep(nanoseconds: nanoseconds)
    }
    
    /// Calculates the navigation title.
    /// If the current round is -1, only the description is shown
    /// (useful for KeyExpansion, Encryption, and Decryption).
    var navigationTitle: String {
        let languageCode = UserDefaults.standard.string(forKey: StorageKeys.appLanguage.key)
        
        let operationName = operationDetails.operationName.description
        if operationDetails.currentRound == -1 {
            return operationName
        }
        
        let inversePrefix = operationDetails.isInverseMode ? "Inverse " : ""
        return "\(inversePrefix)\(operationName) (\(languageCode == "de" ? "Runde" : "Round") \(operationDetails.currentRound))"
    }
    
    // Helper variables for the functions
    private var reverseAnimationSteps: [AnimationStep] {
        animationData.reverseAnimationSteps
    }
    
    private var animationSteps: [AnimationStep] {
        animationData.animationSteps
    }
    
    @MainActor
    func processAnimations() async {
        /// For reverse animations, triggered after clicking the `Reversed` button
        /// in the view
        var index = animationControl.isBackward ? reverseAnimationSteps.count - 1 : 0
        
        handleAnimationState(isDone: false)
        
        /// Loop through the `animationSteps` / `reverseAnimationSteps`
        while index < animationSteps.count && index >= 0 {
            guard !Task.isCancelled else { return }
            
            /// Calculating Delay
            let stepDelay = animationSteps[index].delay
            let revStepDelay = reverseAnimationSteps[index].delay
            let delay = !animationControl.isBackward ? stepDelay : revStepDelay
            let shortDelay = delay > 0 ? delay - 50_000_000 : 0
            let extraShortDelay = shortDelay / 2
            
            /// Executes the animation based on the current `animationControl` state.
            if !animationControl.isBackward {
                await animationSteps[index].animation()
                await sleep(for: animationControl.isForward
                            ? (animationControl.isDouble ? extraShortDelay : shortDelay)
                            : stepDelay)
                index += 1
            } else {
                await reverseAnimationSteps[index].animation()
                await sleep(for: animationControl.isDouble ? extraShortDelay : revStepDelay)
                index -= 1
            }
            
            /// Check if the animation is paused
            while animationControl.isPaused && (index < animationSteps.count && index >= 0) {
                /// Execution Steps for plus and minus button
                if animationControl.plusTriggered {
                    /// Reset `animationControl` flags
                    animationControl.isBackward = false
                    animationControl.isForward = false
                    
                    await animationSteps[index].animation()
                    
                    /// Animations with zero delay trigger the next animation immediately.
                    while index + 1 < animationSteps.count && animationSteps[index].delay == 0 {
                        index += 1
                        await animationSteps[index].animation()
                    }
                    
                    index += 1
                    animationControl.plusTriggered = false
                } else if animationControl.minusTriggered {
                    /// Some animations require the `isBackward` flag to indicate that the animation
                    /// runs in reverse.
                    animationControl.isBackward = true
                    animationControl.isForward = false
                    
                    await reverseAnimationSteps[index].animation()
                    
                    while index < animationSteps.count && index - 1 >= 0 && reverseAnimationSteps[index].delay == 0 {
                        index -= 1
                        await reverseAnimationSteps[index].animation()
                    }
                    
                    index -= 1
                    animationControl.minusTriggered = false
                } else {
                    /// Pause the animation and set the loop to sleep
                    await sleep(for: 100_000_000)
                }
            }
        }
        
        handleAnimationState(isDone: true)
    }
    
    private func handleAnimationState(isDone: Bool) {
        withAnimation {
            animationControl.isDone = isDone
            isDone ? animationControl.resetAnimationFlags() : animationControl.changePause(to: false)
        }
    }
    
    @MainActor
    func startAnimations() {
        animationData.animationTask = Task {
            animationControl.changePause(to: false)
            await sleep(for: short)
            await processAnimations()
        }
    }
    
    private func cancelAndResetAnimation(state: [[Byte]], showResult: Double) {
        animationData.animationTask?.cancel()
        Task { await sleep(for: normal) }
        self.resetAnimationState(state: state, showResult: showResult)
        
        withAnimation {
            self.animationControl.resetAnimationFlags()
            self.animationControl.isDone = true
        }
    }
    
    /// Resets the animation state to the beginning.
    func resetAnimations() { cancelAndResetAnimation(state: copyOfMatrix, showResult: 0.0) }
    
    /// Completes the animation and displays the final result.
    func completeAnimations() { cancelAndResetAnimation(state: result, showResult: 1.0) }
    
    /// Checks if the `isDouble` flag in `animationControl` is set, waits for the specified duration,
    /// and then executes the animation to ensure smoothness.
    ///
    /// - Parameter nanoseconds: The amount of time to wait before running the animation, in nanoseconds.
    func checkDoubleAnimation(for nanoseconds: UInt64 = 200_000_000) async {
        if animationControl.isDouble {
            await sleep(for: nanoseconds)
        }
    }
}
