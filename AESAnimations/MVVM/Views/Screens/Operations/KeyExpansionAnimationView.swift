//
//  KeyExpansionView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.08.24.
//

import SwiftUI

struct KeyExpansionAnimationView: View {
    @StateObject var viewModel: KeyExpansionViewModel 
    let columns = Array(repeating: GridItem(.flexible(minimum: 230)), count: 4)
    
    var buttonTitle: LocalizedStringKey { "Rundenschlüssel-Verlauf" }
    
    // MARK: -
    var body: some View {
        if viewModel.showSubBytes {
            SubBytesAnimationView(viewModel: viewModel.subBytesViewModel,
                                  showRepeatButtons: false)
        } else {
            AnimationContainerView(viewModel: viewModel) {
                VStack(alignment: .leading, spacing: 50) {
                    if !viewModel.animationControl.isDone {
                        keyAnimationSection
                    }
                    roundKeyGrid
                }
            }
            .toolbar(content: keyExpRoundsButton)
            .specificNavigation(isPresented: $viewModel.showKeyExpRounds) {
                RoundKeyHistory(navigationTitle: buttonTitle,
                                keyExpRounds: viewModel.keyExpRounds)
            }
        }
    }
    
    // MARK: - Calculation View
    private var keyAnimationSection: some View {
        HStack(spacing: 25) {
            columnOne
            OperationSymbolView(text: "⊕", isVisible: viewModel.showFirstXOR)
            columnTwo
            
            if viewModel.startRCONAnimation {
                OperationSymbolView(text: "⊕", isVisible: viewModel.showSecondXOR)
                rconAnimationSection
            }
            
            OperationSymbolView(text: "=", isVisible: viewModel.showEqual)
            columnResult
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var columnOne: some View {
        ColumnView(column: viewModel.columnOne,
                   opacity: viewModel.showColumnOne,
                   highlightColumn: true)
    }
    
    private var columnTwo: some View {
        VStack(spacing: 10) {
            if viewModel.showAnimationText {
                Text(viewModel.animationText)
                    .font(.title)
            }
            ColumnView(column: viewModel.columnTwo,
                       position: viewModel.positionKey,
                       opacity: viewModel.showColumnTwo,
                       highlightColumn: true)
        }
    }
    
    private var columnResult: some View {
        ColumnView(column: viewModel.columnResult,
                   opacity: viewModel.showResult,
                   highlightColumn: true)
    }
    
    // MARK: - RCON View
    private var rconAnimationSection: some View {
        HStack(spacing: 10) {
            ForEach(1..<viewModel.rConstants.count, id: \.self) { row in
                ColumnView(
                    column: viewModel.rConstants[row],
                    backgroundColor: viewModel.highlightRCon[row] ? .yellow : .yellow.opacity(0.3)
                )
            }
        }
        .opacity(viewModel.showRCONs)
    }
    
    // MARK: - Round Keys View
    private var roundKeyGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(0..<viewModel.roundKeys.count / 4,
                        id: \.self,
                        content: roundKeySection(for:))
            }
        }
    }
    
    private func roundKeySection(for groupIndex: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Rundenschlüssel \(groupIndex + 1)")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(viewModel.showRoundKeyColumn[groupIndex * 4])
            
            HStack(spacing: 10) {
                ForEach(0..<4, id: \.self) { row in
                    let index = groupIndex * 4 + row
                    
                    ColumnView(column: viewModel.roundKeys[index],
                               opacity: viewModel.showRoundKeyColumn[index],
                               highlightColumn: viewModel.highlightColumn[index])
                }
            }
        }
    }
    
    // MARK: - Toolbar Item
    private func keyExpRoundsButton() -> some ToolbarContent {
        ToolbarItem {
            CustomButtonView(title: buttonTitle,
                             buttonStyle: .secondary,
                             action: viewModel.toggleKeyExpRounds)
            .opacity(viewModel.animationControl.isDone ? 1 : 0)
        }
    }
}

