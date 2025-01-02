//
//  AnimationContainerView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 17.08.24.
//

import SwiftUI

struct AnimationContainerView<Content: View, ViewModel: AnimationViewModelProtocol>: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var viewModel: ViewModel
    var showReverseAnimationButton: Bool
    var showRepeatButtons: Bool
    var showPlusMinusButtons: Bool
    let content: Content
    
    // MARK: - Initializer
    init(viewModel: ViewModel,
         showReverseAnimationButton: Bool? = nil,
         showRepeatButtons: Bool = true,
         showPlusMinusButtons: Bool = true,
         @ViewBuilder content: () -> Content) {
        
        self.viewModel = viewModel
        self.showReverseAnimationButton = showReverseAnimationButton ?? UserDefaults.standard.bool(forKey: StorageKeys.includeReverseAnimation.key)
        self.showRepeatButtons = showRepeatButtons
        self.showPlusMinusButtons = showPlusMinusButtons
        self.content = content()
    }
    
    // MARK: -
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let frameWidth = width * 0.95
                let frameHeight = height * 0.95
                
                VStack {
                    content
                        .frame(width: frameWidth, height: frameHeight)
                        .position(x: width / 2, y: height / 2)
                        .onAppear { performAppearance(geometry: geometry) }
                        .onDisappear(perform: performDisappearance)
                        .onChange(of: scenePhase) { performOnChange(oldValue: $0, newValue: $1) }
                    
                    AnimationControlsView(animationControl: $viewModel.animationControl,
                                          startAnimations: viewModel.startAnimations,
                                          completeAnimations: viewModel.completeAnimations,
                                          resetAnimation: viewModel.resetAnimations,
                                          showRepeatButtons: showRepeatButtons,
                                          showReverseAnimationButton: showReverseAnimationButton,
                                          showPlusMinusButtons: showPlusMinusButtons)
                    .padding(.bottom, padding)
                    .frame(width: frameWidth,
                           height: frameHeight,
                           alignment: checkAlignment() ? .bottomLeading : .bottom)
                    
                }
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        #if os(iOS)
        .navigationBarBackButtonHidden(!viewModel.animationControl.isDone)
        .navigationBarTitleDisplayMode(.inline)
        #else
        .customNavigationBackButton(isDone: viewModel.animationControl.isDone)
        #endif
    }
    
    // MARK: - View functions
    private var operationName: OperationNames {
        viewModel.operationDetails.operationName
    }
    
    private func performAppearance(geometry: GeometryProxy) {
        if viewModel.animationData.animationSteps.isEmpty || viewModel.animationData.reverseAnimationSteps.isEmpty {
            viewModel.createAnimationSteps(with: geometry)
            viewModel.checkAnimationStart()
        }
        
        #if os(macOS)
        // Disable window scaling via the zoom button
        // and prevent windows from being resizable
        // ProcessView can change Window Size
        if operationName != .decryptionProcess && operationName != .encryptionProcess {
            updateWindowResizability(isResizable: false)
        }
        #endif
    }
    
    private func performDisappearance() {
        updateWindowResizability(isResizable: true)
    }
    
    private func performOnChange(oldValue: ScenePhase, newValue: ScenePhase) {
        if newValue != .active {
            viewModel.animationControl.changePause(to: true)
        }
    }
    
    // MARK: - Helper functions / Computed Properties
    private func updateWindowResizability(isResizable: Bool) {
        #if os(macOS)
        for window in NSApplication.shared.windows {
            if let zoomButton = window.standardWindowButton(.zoomButton) {
                zoomButton.isEnabled = isResizable
            }
            
            if isResizable {
                window.styleMask.insert(.resizable)
            } else {
                window.styleMask.remove(.resizable)
            }
        }
        #endif
    }
    
    private func checkAlignment() -> Bool {
        operationName == .subBytes
        || operationName == .addRoundKey
        || operationName == .invSBox
        || operationName == .sBox
        || operationName == .subWord
    }
    
    private var padding: CGFloat {
        operationName != .encryptionProcess && operationName != .decryptionProcess ? 35 : 20
    }
}
