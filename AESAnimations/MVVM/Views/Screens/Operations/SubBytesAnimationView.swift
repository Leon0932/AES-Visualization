//
//  SubBytesView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 06.07.24.
//

import SwiftUI

struct SubBytesAnimationView: View {
    @StateObject var viewModel: SubBytesViewModel
    var showRepeatButtons: Bool = true
    
    // MARK: -
    var body: some View {
        AnimationContainerView(viewModel: viewModel, showRepeatButtons: showRepeatButtons) {
            HStack {
                currentStateView
                sBoxView
                    .padding(.top, 85)
            }
        }
        .toolbar(content: sBoxAnimationButton)
        .specificNavigation(isPresented: $viewModel.showSBoxAnimation) {
            SBoxAnimationView(viewModel: viewModel.sBoxAnimationViewModel)
        }
    }
    
    // MARK: - State View
    private var currentStateView: some View {
        let searchPosition = viewModel.searchStatePosition
        
        return VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.animationControl.isDone ? "Neuer Zustand" : "Aktueller Zustand")
                .font(.headline)
            
            stateGridView
            
            Text("Suche Byte")
                .offset(x: searchPosition.x, y: searchPosition.y)
                .opacity(viewModel.searchState)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var stateGridView: some View {
        VStack(spacing: 10) {
            ForEach(0..<viewModel.state.count, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<viewModel.state[row].count, id: \.self) { col in
                        let position = viewModel.positions[row][col]
                        
                        cellStack(row: row, col: col)
                            .frame(width: 40, height: 40)
                            .offset(x: position.x, y: position.y)
                    }
                }
            }
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
                boxSize: 40,
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
