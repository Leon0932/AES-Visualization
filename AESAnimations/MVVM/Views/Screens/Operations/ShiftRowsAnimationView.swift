//
//  ShiftRowsAnimationView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 11.08.24.
//

import SwiftUI

struct ShiftRowsAnimationView: View {
    @Environment(\.locale) var locale
    @StateObject var viewModel: ShiftRowsViewModel
    
    var buttonTitle: String {
        locale == Locale(identifier: "de") ? "ShiftRows-Verlauf" : "ShiftRows History"
    }
    
    // MARK: -
    var body: some View {
        AnimationContainerView(viewModel: viewModel) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Zustand")
                    .font(.title)
                
                VStack(spacing: 10) {
                    ForEach(0..<4,
                            id: \.self,
                            content: rowView(for:))
                }
            }
            .toolbar(content: keyExpRoundsButton)
        }
        .specificNavigation(isPresented: $viewModel.showShiftRounds) {
            ShiftRowHistory(navigationTitle: buttonTitle, shiftRowRounds: viewModel.shiftRowRounds)
        }
    }
    
    // MARK: - Row View
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
    private func cellRow(for row: Int) -> some View {
        HStack(spacing: 10) {
            ForEach(0..<4, id: \.self) { col in
                let value = viewModel.state[row][col]
                let positions = viewModel.positionCell[row][col]
                
                CellView(value: value,
                         boxSize: 70,
                         backgroundColor: .reducedByteColor(value))
                .offset(x: positions.x, y: positions.y)
            }
        }
    }
    
    // MARK: - Toolbar Item
    private func keyExpRoundsButton() -> some ToolbarContent {
        ToolbarItem {
            CustomButtonView(title: LocalizedStringKey(buttonTitle),
                             buttonStyle: .secondary,
                             action: viewModel.toggleShiftRounds)
            .opacity(viewModel.animationControl.isDone ? 1 : 0)
        }
    }
}
