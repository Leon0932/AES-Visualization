//
//  AnimationViewModelv2.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 12.09.24.
//

import SwiftUI

/// Protocol defining requirements for a view model that manages animations.
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

/// Implementation of animation control logic.
extension AnimationViewModel {
    // Standard values for the animation duration
    /// 1 second
    var normal: UInt64 { return 1_000_000_000 }
    
    /// 0.5 seconds
    var short: UInt64 { return 500_000_000 }
    
    /// Flag to start the animation after appearing the view
    var animationOnAppearKey: Bool {
        UserDefaults.standard.bool(forKey: StorageKeys.startAnimationOnAppear.key)
    }
    
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
    
    /// Processes the animation steps based on the current animation control state.
    ///
    /// This function handles the animation flow, determining the direction (`forward` or `backward`), applying delays between steps,
    /// and respecting pause and control triggers (e.g., "plus" or "minus" actions).
    ///
    /// The function performs the following tasks:
    /// - Executes animations sequentially in the specified direction.
    /// - Handles delays between animations based on the index.
    /// - Responds to user controls such as reversing direction or triggering specific steps.
    /// - Pauses and resumes animation processing as needed.
    @MainActor
    func processAnimations() async {
        /// For reverse animations, triggered after clicking the `Reversed` button
        /// in the view
        var index = animationControl.direction == .backward ? reverseAnimationSteps.count - 1 : 0
        handleAnimationState(isDone: false)
        
        /// Loop through the `animationSteps` / `reverseAnimationSteps`
        while index < animationSteps.count && index >= 0 {
            guard !Task.isCancelled else { return }
            
            /// Executes the animation based on the current `animationControl` state.
            if animationControl.direction == .normal || animationControl.direction == .forward {
                await animationSteps[index].animation()
                await sleep(for: calculateDelay(index: index))
                index += 1
            } else {
                await reverseAnimationSteps[index].animation()
                await sleep(for: calculateDelay(index: index))
                index -= 1
            }
            
            /// Check if the animation is paused
            while animationControl.isPaused && (index < animationSteps.count && index >= 0) {
                /// Execution Steps for plus and minus button
                if animationControl.plusTriggered {
                    /// Reset `animationControl` flags
                    animationControl.direction = .normal
                    animationControl.speed = .normal
        
                    
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
                    animationControl.direction = .backward
                    animationControl.speed = .normal
                    
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
    
    /// Calculates the delay for the current animation step based on the animation control state.
    ///
    /// This function determines the delay for the specified animation step by checking its associated delay value
    /// and adjusting it according to the current `speed` setting (`normal`, `double`, or `triple`) and the animation direction.
    ///
    /// - Parameter index: The index of the current animation step.
    /// - Returns: The calculated delay in nanoseconds, considering the animation speed and direction.
    private func calculateDelay(index: Int) -> UInt64 {
        let stepDelay = animationSteps[index].delay
        let revStepDelay = reverseAnimationSteps[index].delay
        let baseDelay = animationControl.direction == .forward || animationControl.direction == .normal
        ? stepDelay
        : revStepDelay
        
        // Calculating Short-Delays
        let shortDelay = baseDelay > 0 ? baseDelay - 50_000_000 : 0
        let doubleShortDelay = shortDelay / 2
        let tripleShortDelay = shortDelay / 3

        switch animationControl.speed {
        case .double:
            return doubleShortDelay
        case .triple:
            return tripleShortDelay
        default:
            return animationControl.direction == .forward || animationControl.direction == .backward
            ? shortDelay
            : baseDelay
        }
    }
    
    /// Updates the animation state based on the provided flag.
    ///
    /// This function sets the animation state by modifying the `animationControl` properties.
    /// If the `isDone` parameter is `true`, it marks the animation as complete and resets relevant flags.
    /// Otherwise, it prepares the animation to start or resume by ensuring it is not paused.
    ///
    /// - Parameter isDone: A flag indicating whether the animation is complete (`true`) or ongoing (`false`).
    private func handleAnimationState(isDone: Bool) {
        withAnimation {
            animationControl.isDone = isDone
            animationControl.animationHasStarted = true
            isDone ? animationControl.resetAnimationFlags() : animationControl.changePause(to: false)
        }
    }
    
    /// Handles the start of the animation by checking the appropriate flags.
    @MainActor
    func handleAnimationStart() {
        if animationOnAppearKey || animationControl.animationHasStarted {
            startAnimations()
        }
    }
    
    /// Initiates the animation process by preparing and starting the animation task.
    @MainActor
    func startAnimations() {
        animationData.animationTask = Task {
            await sleep(for: short)
            await processAnimations()
        }
    }
    
    // MARK: - Helper Functions
    /// Cancels or completes an animation and resets its state.
    ///
    /// This function cancels any ongoing animation task, resets the animation state, and optionally displays the result.
    /// It ensures the animation flags are reset and marks the animation as complete.
    ///
    /// - Parameters:
    ///   - state: The state to reset the animation to.
    ///   - showResult: A flag indicating whether to display the results after resetting.
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
    
    /// Ensures smooth animation execution by checking the animation speed and applying a delay if necessary.
    ///
    /// This function checks if the animation speed in `animationControl` is set to a value other than `.normal`.
    /// If so, it waits for the specified duration before proceeding, allowing smoother transitions during animations.
    ///
    /// - Parameter nanoseconds: The duration to wait before executing the animation, in nanoseconds. Defaults to `400_000_000`.
    func checkAnimationSpeed(for nanoseconds: UInt64 = 400_000_000) async {
        if animationControl.speed != .normal {
            await sleep(for: nanoseconds)
        }
    }
}
