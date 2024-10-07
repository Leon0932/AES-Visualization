//
//  SubBytesView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 06.07.24.
//

import SwiftUI

struct SubBytesAnimationView: View {
    @StateObject var viewModel: SubBytesViewModel
    
    // MARK: -
    var body: some View {
        AnimationContainerView(viewModel: viewModel) {
            HStack {
                currentStateView
                sBoxView
                    .padding(.top, 50)
            }
        }
    }
    
    // MARK: - State View
    private var currentStateView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.animationControl.isDone ? "Neuer State" : "Aktueller State")
                .font(.headline)
            
            stateGridView
            
            Text("Search State")
                .offset(
                    x: viewModel.searchStatePosition.x,
                    y: viewModel.searchStatePosition.y
                )
                .opacity(viewModel.searchState)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var stateGridView: some View {
        VStack(spacing: 10) {
            ForEach(0..<viewModel.state.count, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<viewModel.state[row].count, id: \.self) { col in
                        cellStack(row: row, col: col)
                            .frame(width: 40, height: 40)
                            .offset(
                                x: viewModel.positions[row][col].x,
                                y: viewModel.positions[row][col].y
                            )
                    }
                }
            }
        }
    }
    
    private func cellStack(row: Int, col: Int) -> some View {
        ZStack {
            if viewModel.splitByte[row][col] {
                splitView(value: viewModel.state[row][col])
                    .transition(.scale)
                    .animation(.spring(duration: 0.5), value: viewModel.splitByte[row][col])
            }
            
            CellView(
                value: viewModel.state[row][col],
                boxSize: 40,
                backgroundColor: viewModel.backgroundColor(row: row, col: col),
                foregroundColor: viewModel.foregroundColor(row: row, col: col)
            )
            .opacity(viewModel.splitByte[row][col] ? 0 : 1)
        }
    }
    
    private func splitView(value: Byte) -> some View {
        HStack {
            CellView(
                value: (value & 0xF0) >> 4,
                boxSize: 40,
                backgroundColor: .accentColor,
                foregroundColor: .white,
                valueFormat: .oneDigit
            )
            
            Image(systemName: "arrow.right")
            
            CellView(
                value: value & 0x0F,
                boxSize: 40,
                backgroundColor: .accentColor,
                foregroundColor: .white,
                valueFormat: .oneDigit
            )
        }
    }
    
    // MARK: - S-Box View
    private var sBoxView: some View {
        SBoxView(
            searchResult: $viewModel.searchResult,
            isInverseMode: viewModel.operationDetails.isInverseMode,
            searchX: viewModel.searchX,
            searchY: viewModel.searchY
        )
    }
}
