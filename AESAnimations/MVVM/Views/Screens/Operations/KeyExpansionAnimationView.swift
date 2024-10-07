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
    
    // MARK: -
    var body: some View {
        if viewModel.showSubBytes {
            SubBytesAnimationView(viewModel: viewModel.subBytesViewModel)
        } else {
            AnimationContainerView(viewModel: viewModel) {
                VStack(alignment: .leading, spacing: 50) {
                    if !viewModel.animationControl.isDone { keyAnimationSection }
                    roundKeyGrid
                }
            }
            .toolbar(content: keyExpRoundsButton)
            .platformSpecificNavigation(isPresented: $viewModel.showKeyExpRounds) {
                RoundKeyHistory(keyExpRounds: viewModel.keyExpRounds)
            }
        }
    }
    
    // MARK: - Calculation View
    private var keyAnimationSection: some View {
        HStack(spacing: 25) {
            ColumnView(column: viewModel.columnOne, opacity: viewModel.showColumnOne)
            
            OperationSymbolView(text: "⊕", isVisible: viewModel.showFirstXOR)
            
            VStack(spacing: 10) {
                if viewModel.showAnimationText {
                    Text(viewModel.animationText)
                        .font(.title)
                }
                
                ColumnView(column: viewModel.columnTwo,
                           position: viewModel.positionKey,
                           opacity: viewModel.showColumnTwo)
            }
            
            if viewModel.startRCONAnimation {
                OperationSymbolView(text: "⊕", isVisible: viewModel.showSecondXOR)
                rconAnimationSection
            }
            
            OperationSymbolView(text: "=", isVisible: viewModel.showEqual)
            
            ColumnView(column: viewModel.columnResult, opacity: viewModel.showResult)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: - RCON View
    private var rconAnimationSection: some View {
        HStack(spacing: 10) {
            ForEach(1..<viewModel.rConstants.count, id: \.self) { row in
                ColumnView(
                    column: viewModel.rConstants[row],
                    backgroundColor: viewModel.highlightRCon[row] ? .yellow : .yellow.opacity(0.3),
                    foregroundColor: .primary
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
                    ColumnView(column: viewModel.roundKeys[groupIndex * 4 + row],
                               opacity: viewModel.showRoundKeyColumn[groupIndex * 4 + row],
                               backgroundColor: viewModel.highlightColumn[groupIndex * 4 + row]
                               ? .accentColor
                               : .accentColor.opacity(0.4))
                }
            }
        }
    }
    
    // MARK: - Toolbar Item
    private func keyExpRoundsButton() -> some ToolbarContent {
        ToolbarItem {
            Button("Zeige Schlüsselverlauf") {
                viewModel.showKeyExpRounds.toggle()
            }
            .buttonStyle(BorderedButtonStyle())
            .opacity(viewModel.animationControl.isDone ? 1 : 0)
        }
    }
}

