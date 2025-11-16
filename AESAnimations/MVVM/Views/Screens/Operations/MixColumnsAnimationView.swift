//
//  MixColumnsAnimationView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 16.08.24.
//

import SwiftUI

struct MixColumnsAnimationView: View {
    @StateObject var viewModel: MixColumnsViewModel
    
    // MARK: -
    var body: some View {
        AnimationContainerView(viewModel: viewModel) {
            VStack(spacing: LayoutStyles.spacingBetweenComponentes) {
                calculationView
                    .padding(.leading, 25)
                stateComparisonView
            }
        }
    }
    
    // MARK: - Calculation View
    private var calculationView: some View {
        HStack(spacing: 25) {
            matrixView
            
            OperationSymbol(text: "*",
                            isVisible: viewModel.isShowingMultiplication)
            
            emptyColumnView
            
            OperationSymbol(text: "=",
                            isVisible: viewModel.isShowingEquality)
            
            resultCellView
        }
    }
    
    private var matrixView: some View {
        StateView(state: viewModel.transformationMatrix,
                  backgroundColor: .ultraLightGray)
        .opacity(viewModel.showMatrix)
    }
    
    private var emptyColumnView: some View {
        VStack(spacing: LayoutStyles.spacingMatrix) {
            ForEach(0..<4) { index in
                CellView(value: 0x00, boxSize: LayoutStyles.cellSize, backgroundColor: .clear)
                    .opacity(0)
            }
        }
        .trackPosition { viewModel.positionOfMultiplicableColumn = $0 }
    }
    
    private var resultCellView: some View {
        VStack(spacing: LayoutStyles.spacingMatrix) {
            ForEach(0..<4) { index in
                let value = viewModel.resultOfMixColumn[index]
                
                CellView(
                    value: value,
                    boxSize: LayoutStyles.cellSize,
                    backgroundColor: .reducedByteColor(value)
                )
                .opacity(viewModel.isShowingResult)
            }
        }
    }
    
    // MARK: - Result View
    private var stateComparisonView: some View {
        HStack {
            StateView(title: "Alter Zustand",
                      state: viewModel.state,
                      position: .oneD(viewModel.columnPositions),
                      currentPosition: $viewModel.positionOfOldState)
            
            Spacer()
            
            StateView(title: "Neuer Zustand",
                      state: viewModel.result,
                      opacity: .oneD(viewModel.showNewState))
        }
        .padding(.horizontal, 25)
    }
}
