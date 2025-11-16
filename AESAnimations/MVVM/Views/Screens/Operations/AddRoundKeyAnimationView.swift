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
            VStack(spacing: LayoutStyles.spacingBetweenComponentes) {
                calculationView
                stateAndKeyView
                newStateView
            }
        }
    }
    
    // MARK: - Calculation View
    private var calculationView: some View {
        HStack(spacing: 20) {
            invisibleCellView { viewModel.positionCellState = $0 }
            
            OperationSymbol(text: "⊕",
                            isVisible: viewModel.showXOR)
            
            invisibleCellView { viewModel.positionCellKey = $0 }
            
            OperationSymbol(text: "=",
                            isVisible: viewModel.showEqual)
            resultCellView
        }
    }
    
    private var resultCellView: some View {
        let value = viewModel.resultOfAdd
        
        return CellView(value: value,
                        boxSize: LayoutStyles.cellSize,
                        backgroundColor: .reducedByteColor(value))
        .opacity(viewModel.showResult)
    }
    
    // MARK: - State and Key View
    private var stateAndKeyView: some View {
        HStack {
            StateView(title: "Zustand",
                      state: viewModel.state,
                      position: .twoD(viewModel.positionState),
                      currentPosition: $viewModel.positionStateMatrix)
            
            Spacer()
            
            StateView(title: "Schlüssel",
                      state: viewModel.key,
                      position: .twoD(viewModel.positionKey),
                      currentPosition: $viewModel.positionKeyMatrix)
        }
        
    }
    
    // MARK: - Result View
    private var newStateView: some View {
        StateView(title: "Neuer Zustand",
                  state: viewModel.result,
                  opacity: .twoD(viewModel.showNewState))
    }
    
    // MARK: - Helper functions
    private func invisibleCellView(onPosition: @escaping (Position) -> Void) -> some View {
        CellView(value: 0x00, boxSize: LayoutStyles.cellSize, backgroundColor: .clear)
            .trackPosition(onPosition: onPosition)
            .opacity(0)
    }
}
