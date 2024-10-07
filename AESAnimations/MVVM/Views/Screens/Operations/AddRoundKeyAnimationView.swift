//
//  AddRoundKeyAnimationView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 18.08.24.
//

import SwiftUI

struct AddRoundKeyAnimationView: View {
    @StateObject var viewModel: AddRoundKeyViewModel
    
    // MARK: -
    var body: some View {
        AnimationContainerView(viewModel: viewModel) {
            VStack(spacing: 50) {
                calculationView
                stateAndKeyView
                newStateView
            }
        }
        #if os(iOS)
        .onAppear { viewModel.isPad13Size = isPad13Size() }
        #endif
    }
    
    // MARK: - Calculation View
    private var calculationView: some View {
        HStack(spacing: 12) {
            HStack(spacing: 80) {
                OperationSymbolView(text: "⊕",
                                    isVisible: viewModel.showXOR)
                OperationSymbolView(text: "=",
                                    isVisible: viewModel.showEqual)
            }
            
            resultCellView
        }
        .padding(.bottom)
    }
    
    private var resultCellView: some View {
        CellView(value: viewModel.resultOfAdd,
                 boxSize: 50,
                 backgroundColor: .accentColor,
                 foregroundColor: .white)
        .opacity(viewModel.showResult)
    }
    
    // MARK: - State and Key View
    private var stateAndKeyView: some View {
        HStack {
            StateView(title: "State",
                      state: viewModel.state,
                      position: .twoD(viewModel.positionState),
                      backgroundColor: .reducedAccentColor)
            
            Spacer()
            
            StateView(title: "Key",
                      state: viewModel.key,
                      position: .twoD(viewModel.positionKey),
                      backgroundColor: .lightGray)
        }
        
    }
    
    // MARK: - Result View
    private var newStateView: some View {
        StateView(title: "Neuer State",
                  state: viewModel.result,
                  opacity: .twoD(viewModel.showNewState),
                  backgroundColor: .accentColor,
                  foregroundColor: .white)
    }
}
