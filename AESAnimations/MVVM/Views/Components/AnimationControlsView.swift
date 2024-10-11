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
    
    // MARK: -
    var body: some View {
        ZStack {
            if animationControl.isDone {
                controlButtonsDone
            } else {
                controlButtons
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.5), value: animationControl.isDone)
    }
    
    // MARK: - Buttons for finished animations
    private var controlButtonsDone: some View {
        HStack(spacing: 15) {
            CustomButton<Never>(title: "Animation wiederholen", useMaxWidth: false) {
                withAnimation {
                    resetAnimation()
                    startAnimations()
                }
            }
            
            CustomButton<Never>(title: "Umgekehrt starten", useMaxWidth: false) {
                withAnimation {
                    completeAnimations()
                    animationControl.isBackward = true
                    startAnimations()
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.ultraLightGray)
        )
         
    }
    
    // MARK: - Control buttons
    private var controlButtons: some View {
        HStack(spacing: 50) {
            controlButton(imageName: "arrow.uturn.left.circle.fill", action: resetAnimation)
            backwardControl
            pausePlayControl
            forwardControl
            controlButton(imageName: "checkmark.circle.fill", action: completeAnimations)
        }
        .font(.title2)
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.ultraLightGray))
    }

    // MARK: - Control buttons components
    private var backwardControl: some View {
        HStack(spacing: 15) {
            Text("2x")
                .foregroundColor(.accentColor)
                .opacity(animationControl.isBackward && animationControl.isDouble ? 1 : 0)
                .animation(.easeIn, value: animationControl.isBackward && animationControl.isDouble)
            
            controlButton(imageName: animationControl.isBackward ? "backward.fill" : "backward") {
                withAnimation {
                    animationControl.reverseAnimation()
                }
            }
        }
    }

    // Pause/Play control
    private var pausePlayControl: some View {
        controlButton(imageName: animationControl.isPaused ? "play.fill" : "pause.fill") {
            animationControl.isPaused ? animationControl.changePause(to: false) : animationControl.changePause(to: true)
        }
    }

    // Forward control with animation
    private var forwardControl: some View {
        HStack(spacing: 15) {
            controlButton(imageName: animationControl.isForward ? "forward.fill" : "forward") {
                withAnimation {
                    animationControl.advanceAnimations()
                }
            }
            
            Text("2x")
                .foregroundColor(.accentColor)
                .opacity(animationControl.isForward && animationControl.isDouble ? 1 : 0)
        }
    }
    
    // MARK: - Helper Functions
    private func controlButton(imageName: String, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                Image(systemName: imageName)
            }
            .foregroundColor(Color.accentColor)
            #if os(macOS)
            .buttonStyle(PlainButtonStyle())
            #endif
        }
}

