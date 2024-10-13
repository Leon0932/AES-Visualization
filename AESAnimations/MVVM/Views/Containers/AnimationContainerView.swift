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
    let content: Content
    
    // MARK: - Initializer
    init(viewModel: ViewModel,
         @ViewBuilder content: () -> Content) {
        
        self.viewModel = viewModel
        self.content = content()
    }
    
    // MARK: -
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: checkSubOrAddRoundKey() ? .bottomLeading : .center) {
                    content
                        .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.95)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        .onAppear { viewModel.createAnimationSteps(with: geometry) }
                    
                    VStack {
                        Spacer()
                        
                        
                        AnimationControlsView(animationControl: $viewModel.animationControl,
                                              startAnimations: viewModel.startAnimations,
                                              completeAnimations: viewModel.completeAnimations,
                                              resetAnimation: viewModel.resetAnimations)
                        .padding(.bottom, 10)
                        .padding(checkSubOrAddRoundKey() ? 10 : 0)
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
    func checkSubOrAddRoundKey() -> Bool {
        let operationName = viewModel.operationDetails.operationName
        
        return operationName == .subBytes || operationName == .addRoundKey
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
