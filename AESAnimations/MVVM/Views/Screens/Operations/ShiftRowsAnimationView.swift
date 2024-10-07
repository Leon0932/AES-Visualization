//
//  ShiftRowsAnimationView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import SwiftUI

struct ShiftRowsAnimationView: View {
    @StateObject var viewModel: ShiftRowsViewModel
    
    // MARK: -
    var body: some View {
        AnimationContainerView(viewModel: viewModel) {
            VStack(alignment: .leading, spacing: 10) {
                Text("State")
                    .font(.title)
                
                VStack(spacing: 10) {
                    ForEach(0..<4, id: \.self) { row in
                        rowView(for: row)
                    }
                }
            }
            .toolbar(content: keyExpRoundsButton)
            .platformSpecificNavigation(isPresented: $viewModel.showShiftRounds) {
                ShiftRowHistory(shiftRowRounds: viewModel.shiftRowRounds)
            }
        }
    }
    
    // MARK: - Row View
    @ViewBuilder
    private func rowView(for row: Int) -> some View {
        HStack(spacing: 12) {
            cellRow(for: row)
            
            Label("Linksverschiebung um \(shiftAmount(for: row))-Shifts", systemImage: "arrow.left")
                .font(.title)
                .opacity(viewModel.isShiftTextVisible[row] ? 1 : 0)
                .animation(.easeIn(duration: 0.5), value: viewModel.isShiftTextVisible[row])
        }
    }
    
    private func shiftAmount(for row: Int) -> Int {
        row != 0 && viewModel.operationDetails.isInverseMode ? 3 - (row - 1) : row
    }
    
    // MARK: - Cell View
    @ViewBuilder
    private func cellRow(for row: Int) -> some View {
        HStack(spacing: 10) {
            ForEach(0..<4, id: \.self) { col in
                CellView(value: viewModel.state[row][col],
                         boxSize: 70,
                         backgroundColor: .accentColor,
                         foregroundColor: .white)
                .offset(x: viewModel.positionCell[row][col].x,
                        y: viewModel.positionCell[row][col].y)
            }
        }
    }
    
    // MARK: - Toolbar Item
    private func keyExpRoundsButton() -> some ToolbarContent {
        ToolbarItem {
            Button("Zeige ShiftRows-Verlauf") {
                viewModel.showShiftRounds.toggle()
            }
            .buttonStyle(BorderedButtonStyle())
            .opacity(viewModel.animationControl.isDone ? 1 : 0)
        }
    }
}
