//
//  MixColumnAnimationView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 16.08.24.
//

import SwiftUI

struct MixColumnAnimationView: View {
    @StateObject var viewModel: MixColumnsViewModel
    
    // MARK: -
    var body: some View {
        AnimationContainerView(viewModel: viewModel) {
            VStack(spacing: 50) {
                HStack(spacing: 20) {
                    matrixView
                    operationSymbols
                    resultCellView
                }
                .padding(.leading, 25)
                stateComparisonView
            }
        }
    }
    
    // MARK: - Calculation View
    private var matrixView: some View {
        StateView(state: viewModel.transformationMatrix,
                  backgroundColor: .ultraLightGray)
    }
    
    private var operationSymbols: some View {
        HStack(spacing: 32) {
            OperationSymbolView(text: "*",
                                isVisible: viewModel.isShowingMultiplication)
            OperationSymbolView(text: "=",
                                isVisible: viewModel.isShowingEquality,
                                leadingPadding: 50)
        }
    }
    
    private var resultCellView: some View {
        VStack(spacing: 10) {
            ForEach(0..<4) { index in
                let value = viewModel.resultOfMixColumn[index]
                
                CellView(
                    value: value,
                    boxSize: 50,
                    backgroundColor: .reducedByteColor(value)
                )
                .opacity(viewModel.isShowingResult)
            }
        }
    }
    
    // MARK: - Result View
    private var stateComparisonView: some View {
        HStack {
            StateView(title: "Alter State",
                      state: viewModel.state,
                      position: .oneD(viewModel.columnPositions)
            )
            Spacer()
            StateView(title: "Neuer State",
                      state: viewModel.result,
                      opacity: .oneD(viewModel.showNewState))
        }
        .padding(.horizontal, 25)
    }
}
