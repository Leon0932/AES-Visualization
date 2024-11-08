//
//  AnimationContainerView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 17.08.24.
//

import SwiftUI

struct AnimationContainerView<Content: View, ViewModel: AnimationViewModel>: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: ViewModel
    var showReverseAnimationButton: Bool
    var showRepeatButtons: Bool
    let content: Content
    
    // MARK: - Initializer
    init(viewModel: ViewModel,
         showReverseAnimationButton: Bool? = nil,
         showRepeatButtons: Bool = true,
         @ViewBuilder content: () -> Content) {
        
        self.viewModel = viewModel
        self.showReverseAnimationButton = showReverseAnimationButton ?? UserDefaults.standard.bool(forKey: "includeReverseAnimation")
        self.showRepeatButtons = showRepeatButtons
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
                        .onAppear { viewModel.createAnimationSteps(with: geometry) }
                    
                    VStack {
                        Spacer()
                        
                        
                        AnimationControlsView(animationControl: $viewModel.animationControl,
                                              startAnimations: viewModel.startAnimations,
                                              completeAnimations: viewModel.completeAnimations,
                                              resetAnimation: viewModel.resetAnimations,
                                              showRepeatButtons: showRepeatButtons,
                                              showReverseAnimationButton: showReverseAnimationButton)
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
