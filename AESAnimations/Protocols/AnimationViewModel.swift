//
//  AnimationViewModelv2.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 12.09.24.
//

import SwiftUI


/// This is a test command
protocol AnimationViewModel: ObservableObject {
    /// View Variables
    var operationDetails: OperationDetails { get }
    
    /// State Variable
    var result: [[Byte]] { get }
    var copyOfState: [[Byte]] { get }
    
    /// Animation Controllers
    var animationControl: AnimationControl { get set }
    var animationTask: Task<Void, Never>? { get set }
    var animationSteps: [AnimationStep] { get set }
    var reverseAnimationSteps: [AnimationStep] { get set }
    
    @MainActor
    func createAnimationSteps(with geometry: GeometryProxy)
    func resetAnimationState(state newState: [[Byte]], showResult: Double)
    
}

extension AnimationViewModel {
    
    // Standard values for the animation duration
    /// 1 nanosecond
    var normal: UInt64 { return 1_000_000_000 }
    
    /// 0,5 nanoseconds
    var short: UInt64 { return 500_000_000 }
    
    func sleep(for nanoseconds: UInt64) async {
        try? await Task.sleep(nanoseconds: nanoseconds)
    }
    
    // General implementation for calculating the title
    // -1: Only the description is shown (useful for KeyExpansion, Encryption and Decryption)
    var navigationTitle: String {
        if operationDetails.currentRound == -1 { return operationDetails.operationName.description }
        
        let inversePrefix = operationDetails.isInverseMode ? "Inverse " : ""
        return "\(inversePrefix)\(operationDetails.operationName.description) (Runde \(operationDetails.currentRound))"
    }
    
    @MainActor
    func processAnimations() async {
        var index = animationControl.isBackward ? reverseAnimationSteps.count - 1 : 0
        
        withAnimation {
            animationControl.isPaused = false
            animationControl.isDone = false
        }
        
        while index < animationSteps.count && index >= 0 {
            print("CANCEL \(Task.isCancelled)")
            guard !Task.isCancelled else {
                print("Task is canceled \(operationDetails.operationName)")
                return
            }
            
            print("Index: \(index), Operation: \(operationDetails.operationName)")
            
            if !animationControl.isBackward {
                await animationSteps[index].animation()
                await sleep(for: animationControl.isForward
                            ? (animationControl.isDouble ? 200_000_000 : 400_000_000)
                            : animationSteps[index].delay)
                index += 1
            } else {
                await reverseAnimationSteps[index].animation()
                await sleep(for: animationControl.isDouble ? 200_000_000 : reverseAnimationSteps[index].delay)
                index -= 1
            }
            
            // Check if animation was paused
            while animationControl.isPaused { await sleep(for: 100_000_000) }
        }
        
        // Set the animation to 'done'
        withAnimation {
            animationControl.isDone = true
            animationControl.resetAnimationFlags()
        }
    }
    
    @MainActor
    func startAnimations() {
        animationTask = Task {
            animationControl.isPaused = false
            await sleep(for: short)
            await processAnimations()
        }
    }
    
    private func cancelAndResetAnimation(state: [[Byte]], showResult: Double) {
        animationTask?.cancel()
        Task { await sleep(for: normal) }
        
        self.resetAnimationState(state: state, showResult: showResult)
        
        
        withAnimation{
            self.animationControl.resetAnimationFlags()
            self.animationControl.isDone = true
        }
        
        
        
    }
    
    func resetAnimations() {
        cancelAndResetAnimation(state: copyOfState, showResult: 0.0)  
    }
    
    func completeAnimations() {
        cancelAndResetAnimation(state: result, showResult: 1.0)
        
    }
    
    func checkDoubleAnimation(for nanoseconds: UInt64 = 200_000_000) async {
        if animationControl.isDouble {
            await sleep(for: nanoseconds)
        }
    }
}
