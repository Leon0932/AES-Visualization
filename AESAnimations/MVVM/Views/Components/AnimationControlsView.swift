//
//  AnimationControlsView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 03.09.24.
//

import SwiftUI

struct AnimationControlsView: View {
    // MARK: - Properties
    @Binding var animationControl: AnimationControl
    
    var startAnimations: () -> Void
    var completeAnimations: () -> Void
    var resetAnimation: () -> Void
    
    var showRepeatButtons: Bool = true
    var showReverseAnimationButton: Bool = true
    
    // MARK: -
    var body: some View {
        ZStack {
            if animationControl.isDone {
                if showRepeatButtons { controlButtonsDone }
            } else {
                controlButtons
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.5), value: animationControl.isDone)
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
    
    private func repeatAnimation() {
        withAnimation {
            resetAnimation()
            startAnimations()
        }
    }
    
    private func startReverseAnimation() {
        withAnimation {
            completeAnimations()
            animationControl.isBackward = true
            startAnimations()
        }
    }
    
    // MARK: - Control buttons
    private var controlButtons: some View {
        HStack(spacing: 35) {
            controlButton(icon: "arrow.uturn.left.circle.fill", action: resetAnimation)
            controlStack(isForward: false)
            pausePlayControl
            controlStack(isForward: true)
            controlButton(icon: "checkmark.circle.fill", action: completeAnimations)
        }
        .font(.title2)
        .padding(15)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.ultraLightGray))
    }
    
    // MARK: - Control buttons components
    private var pausePlayControl: some View {
        controlButton(icon: animationControl.isPaused ? "play.fill" : "pause.fill") {
            animationControl.isPaused ? animationControl.changePause(to: false) : animationControl.changePause(to: true)
        }
    }
    
    private func controlStack(isForward: Bool) -> some View {
        HStack(spacing: 10) {
            if isForward {
                controlButton(icon: animationControl.isForward ? "forward.fill" : "forward") {
                    withAnimation {
                        animationControl.advanceAnimations()
                    }
                }
                   
                Text("2x")
                    .foregroundStyle(Color.accentColor)
                    .opacity(animationControl.isForward && animationControl.isDouble ? 1 : 0)
                
            } else {
                Text("2x")
                    .foregroundStyle(Color.accentColor)
                    .opacity(animationControl.isBackward && animationControl.isDouble ? 1 : 0)
                
                
                controlButton(icon: animationControl.isBackward ? "backward.fill" : "backward") {
                    withAnimation {
                        animationControl.reverseAnimation()
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    private func controlButton(icon: String, action: @escaping () -> Void) -> some View {
        CustomButtonView(icon: icon,
                         buttonStyle: StandardButtonStyle(font: .title2),
                         action: action)
    }
}

