//
//  AnimationControlsView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 03.09.24.
//

import SwiftUI

/// A helper view for controlling the animation.
struct AnimationControlsView: View {
    // MARK: - Properties
    @Binding var animationControl: AnimationControl
    
    var startAnimations: () -> Void
    var completeAnimations: () -> Void
    var resetAnimation: () -> Void
    
    var showRepeatButtons: Bool = true
    var showReverseAnimationButton: Bool = true
    var showPlusMinusButtons: Bool = true
    
    @AppStorage(StorageKeys.startAnimationOnAppear.key) var startAnimationOnApp: Bool = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            if animationControl.isDone {
                if showRepeatButtons { controlButtonsDone }
            } else if !animationControl.animationHasStarted && !startAnimationOnApp {
                startButton
            } else {
                controlButtons
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.5), value: animationControl.isDone)
    }
    
    // MARK: - Start Button
    private var startButton: some View {
        CustomButtonView(title: "Animation starten",
                         icon: "play.circle",
                         buttonStyle: .primary) {
            withAnimation { startAnimations() }
        }
    }
    
    // MARK: - Buttons for finished animations
    private var controlButtonsDone: some View {
        let secondaryButton = SecondaryButtonStyle(padding: 16, font: .headline)
        
        return HStack(spacing: 15) {
            CustomButtonView(title: "Wiederholen",
                             icon: "repeat",
                             buttonStyle: secondaryButton,
                             action: repeatAnimation)
            
            if showReverseAnimationButton {
                CustomButtonView(title: "Umgekehrt",
                                 icon: "arrowshape.turn.up.backward",
                                 buttonStyle: secondaryButton,
                                 action: startReverseAnimation)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.ultraLightGray)
        )
    }
    
    // MARK: - Control buttons
    private var controlButtons: some View {
        HStack(spacing: 25) {
            controlButton(icon: "arrow.uturn.left.circle.fill", action: resetAnimation)
            controlStack(isForward: false)
            pausePlayControl
            controlStack(isForward: true)
            controlButton(icon: "checkmark.circle.fill", action: completeAnimations)
        }
        .font(.title2)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10).fill(Color.ultraLightGray)
        )
    }
    
    // MARK: - Control buttons components
    private var pausePlayControl: some View {
        controlButton(icon: animationControl.isPaused ? "play.fill" : "pause.fill", action: pauseAnimation)
    }
    
    private func controlStack(isForward: Bool) -> some View {
        HStack(spacing: 5) {
            if isForward {
                forwardButton()
                doubleTextView(showText: animationControl.direction == .forward && animationControl.speed != .normal)
            } else {
                doubleTextView(showText: animationControl.direction == .backward && animationControl.speed != .normal)
                backwardButton()
            }
        }
    }
    
    private func forwardButton() -> some View {
        if animationControl.isPaused && showPlusMinusButtons {
            controlButton(icon: "plus") { animationControl.plusTriggered = true }
        } else {
            controlButton(icon: animationControl.direction == .forward ? "forward.fill" : "forward") {
                withAnimation { animationControl.handleAnimation(direction: .forward) }
            }
        }
    }
    
    private func backwardButton() -> some View {
        if animationControl.isPaused && showPlusMinusButtons {
            controlButton(icon: "minus") { animationControl.minusTriggered = true }
        } else {
            controlButton(icon: animationControl.direction == .backward ? "backward.fill" : "backward") {
                withAnimation { animationControl.handleAnimation(direction: .backward) }
            }
        }
    }

    // MARK: - Helper Functions

    /// A button for displaying a single control component.
    ///
    /// - Parameters:
    ///   - icon: The SF Symbol as a string.
    ///   - action: The action to execute when the control is activated.
    /// - Returns: A custom button view with a standard style.
    private func controlButton(icon: String, action: @escaping () -> Void) -> some View {
        CustomButtonView(icon: icon,
                         buttonStyle: StandardButtonStyle(font: .title2),
                         action: action)
    }
    
    /// A view for displaying the animation speed.
    ///
    /// - Parameter showText: A flag indicating whether to display the text.
    /// - Returns: A styled text view showing the animation speed.
    private func doubleTextView(showText: Bool) -> some View {
        Text(getSpeedText(for: animationControl.speed))
            .foregroundStyle(Color.accentColor)
            .opacity(determineOpacity(showText: showText))
    }
  
    /// Helper function to determine the text representation of the speed.
    ///
    /// - Parameter speed: The current speed direction.
    /// - Returns: A `String` representing the speed.
    private func getSpeedText(for speed: AnimationControl.Speed) -> String {
        if speed == .triple { return "3x" }
        
        return "2x"
    }
    
    private func determineOpacity(showText: Bool) -> Double {
        if showText && !animationControl.isPaused {
            return 1
        }
        if !showPlusMinusButtons && showText {
            return 1
        }
        return 0
    }
    
    // MARK: - Control Functions
    private func pauseAnimation() {
        withAnimation {
            animationControl.changePause(to: !animationControl.isPaused)
        }
    }
    
    private func repeatAnimation() {
        withAnimation {
            resetAnimation()
            startAnimations()
        }
    }
    
    private func startReverseAnimation() {
        withAnimation {
            completeAnimations()
            animationControl.direction = .backward
            startAnimations()
        }
    }
}

