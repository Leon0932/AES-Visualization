//
//  SubBytesView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 06.07.24.
//

import SwiftUI

struct SubBytesAnimationView: View {
    @StateObject var viewModel: SubBytesViewModel
    @Namespace var animationNamespace
    var showRepeatButtons: Bool = true
    var showSBoxButton: Bool = true
    
    // MARK: -
    var body: some View {
        AnimationContainerView(viewModel: viewModel, showRepeatButtons: showRepeatButtons) {
            HStack {
                currentStateView
                searchByteInSBoxView
            }
        }
        .toolbar {
            if showSBoxButton {
                sBoxAnimationButton()
            }
        }
        .specificNavigation(isPresented: $viewModel.showSBoxAnimation) {
            SBoxAnimationView(viewModel: viewModel.sBoxAnimationViewModel)
        }
    }
    
    // MARK: - State View
    private var currentStateView: some View {
        VStack(alignment: .leading, spacing: 10) {
            StateTitle(title: viewModel.animationControl.isDone ? "Neuer Zustand" : "Aktueller Zustand")
            stateGridView
                .trackPosition { viewModel.positionOfCurrentState = $0 }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var searchByteInSBoxView: some View {
        VStack(spacing: 50) {
            result
            sBoxView
        }
    }
    
    private var stateGridView: some View {
        VStack(spacing: LayoutStyles.spacingMatrix) {
            ForEach(0..<viewModel.state.count, id: \.self) { row in
                HStack(spacing: LayoutStyles.spacingMatrix) {
                    ForEach(0..<viewModel.state[row].count, id: \.self) { col in
                        let position = viewModel.positions[row][col]
                        
                        cellStack(row: row, col: col)
                            .frame(width: viewModel.boxSize,
                                   height: viewModel.boxSize)
                            .offset(x: position.x, y: position.y)
                            .matchedGeometryEffect(id: "\(row)-\(col)", in: animationNamespace)
                    }
                }
            }
        }
    }
    
    private var result: some View {
        HStack(spacing: 50) {
            Text("Suche Byte")
                .opacity(viewModel.searchState)
            
            CellView(
                value: 0x00,
                boxSize: viewModel.boxSize,
                backgroundColor: .clear
            )
            .opacity(0)
            .trackPosition { viewModel.positionOfSearchByte = $0 }
            
        }
    }
    
    private func cellStack(row: Int, col: Int) -> some View {
        let splitByte = viewModel.splitByte[row][col]
        let value = viewModel.state[row][col]
        
        return ZStack {
            if splitByte {
                splitView(value: value)
                    .transition(.scale)
                    .animation(.spring(duration: 0.5), value: splitByte)
            }
            
            CellView(
                value: value,
                boxSize: viewModel.boxSize,
                backgroundColor: viewModel.backgroundColor(row: row, col: col)
            )
            .opacity(splitByte ? 0 : 1)
        }
    }
    
    private func splitView(value: Byte) -> some View {
        VStack(spacing: 5) {
            HStack(spacing: 8) {
                CellView(
                    value: (value & 0xF0) >> 4,
                    boxSize: 35,
                    backgroundColor: .activeByteColor(value),
                    valueFormat: .oneDigit
                )
                
                Text("Zeile")
                    .foregroundStyle(Color.primary)
            }
            .frame(width: 100, alignment: .leading)
            
            HStack(spacing: 8) {
                CellView(
                    value: value & 0x0F,
                    boxSize: 35,
                    backgroundColor: .activeByteColor(value),
                    valueFormat: .oneDigit
                )
                
                Text("Spalte")
                    .foregroundStyle(Color.primary)
            }
            .frame(width: 100, alignment: .leading)
            
        }
    }
    
    // MARK: - S-Box View
    private var sBoxView: some View {
        SBoxView(
            isInverseMode: viewModel.operationDetails.isInverseMode,
            sBoxIndex: viewModel.currentByte,
            searchResult: viewModel.searchResult,
            searchX: viewModel.searchX,
            searchY: viewModel.searchY
        )
    }
    
    // MARK: - Toolbar Item
    private func sBoxAnimationButton() -> some ToolbarContent {
        ToolbarItem {
            let sBox = LocalizedStringKey(OperationNames.sBox.description)
            let invSBox = LocalizedStringKey(OperationNames.invSBox.description)
            
            CustomButtonView(title: viewModel.operationDetails.isInverseMode ? invSBox : sBox,
                             buttonStyle: .secondary,
                             action: viewModel.toggleSBoxAnimation)
            .opacity(viewModel.animationControl.isDone ? 1 : 0)
        }
    }
}
