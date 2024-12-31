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
                ZStack(alignment: checkAlignment() ? .bottomLeading : .center) {
                    content
                        .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.95)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        .onAppear {
                            if viewModel.animationData.animationSteps.isEmpty || viewModel.animationData.reverseAnimationSteps.isEmpty {
                                viewModel.createAnimationSteps(with: geometry)
                                viewModel.checkAnimationStart()
                            }
                        }
                        .onChange(of: scenePhase) { oldValue, newValue in
                            if newValue != .active {
                                viewModel.animationControl.changePause(to: true)
                            }
                        }
                    
                    VStack {
                        Spacer()
                        
                        
                        AnimationControlsView(animationControl: $viewModel.animationControl,
                                              startAnimations: viewModel.startAnimations,
                                              completeAnimations: viewModel.completeAnimations,
                                              resetAnimation: viewModel.resetAnimations,
                                              showRepeatButtons: showRepeatButtons,
                                              showReverseAnimationButton: showReverseAnimationButton,
                                              showPlusMinusButtons: showPlusMinusButtons)
                        .padding(.bottom, 10)
                        .padding(.leading, checkAlignment() ? 10 : 0)
                    }
                }
                .frame(width: geometry.size.width)
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        #if os(iOS)
        .navigationBarBackButtonHidden(!viewModel.animationControl.isDone)
        .navigationBarTitleDisplayMode(.inline)
        #else
        .navigationBarBackButtonHidden(true)
        .toolbar(content: toolbarItem)
        #endif
    }
    
    // MARK: - Helper functions
    func checkAlignment() -> Bool {
        let operationName = viewModel.operationDetails.operationName
        
        return operationName == .subBytes
        || operationName == .addRoundKey
        || operationName == .invSBox
        || operationName == .sBox
        || operationName == .subWord
    }
    
    func toolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
            }
            .opacity(viewModel.animationControl.isDone ? 1 : 0)
        }
    }
}
