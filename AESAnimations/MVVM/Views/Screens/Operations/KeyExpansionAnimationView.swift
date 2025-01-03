//
//  KeyExpansionView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 25.08.24.
//

import SwiftUI

struct KeyExpansionAnimationView: View {
    @Environment(\.locale) var locale
    @StateObject var viewModel: KeyExpansionViewModel
    
    var columns: [GridItem] {
        // Block Size: 50
        // Spacing: 10
        if viewModel.showBlockForm {
            switch viewModel.keySize {
            case .key128:
                return Array(repeating: GridItem(.flexible(minimum: viewModel.boxSize * 4), spacing: 15),
                             count: 4)
            case .key192:
                let gridCount: Int
                #if os(iOS)
                gridCount = DeviceDetector.isPad13Size() ? 3 : 2
                #else
                gridCount = DeviceDetector.isLargeWindow() ? 3 : 2
                #endif

                return Array(repeating: GridItem(.flexible(minimum: viewModel.boxSize * 6), spacing: 15),
                             count: gridCount)
            case .key256:
                return Array(repeating: GridItem(.flexible(minimum: viewModel.boxSize * 8), spacing: 15),
                             count: 2)
            }
        } else {
            return Array(repeating: GridItem(.flexible(minimum: viewModel.boxSize * 4)),
                         count: 4)
        }
    }
    
    var buttonTitle: String {
        locale == Locale(identifier: "de") ? "Rundenschlüssel-Verlauf" : "Round Key History"
    }
    
    // MARK: -
    var body: some View {
        if viewModel.showSubWords {
            SubBytesAnimationView(viewModel: viewModel.subBytesViewModel,
                                  showRepeatButtons: false,
                                  showSBoxButton: false)
        } else { 
            AnimationContainerView(viewModel: viewModel, showPlusMinusButtons: false) {
                VStack(alignment: .leading, spacing: 50) {
                    if !viewModel.animationControl.isDone {
                        keyAnimationSection
                            .padding(.top, 25)
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
                    .frame(width: 125) // Smaller iPads (less than 11-Inc), doesn't show the full Title
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
        ZStack(alignment: .top) {
            Text("Rundenkonstante (RCON)")
                .font(.headline)
                .offset(y: -25)
            
            
            HStack(spacing: 10) {
                ForEach(1..<viewModel.rConstants.count, id: \.self) { row in
                    ColumnView(
                        column: viewModel.rConstants[row],
                        backgroundColor: viewModel.highlightRCon[row] ? .yellow : .yellow.opacity(0.3)
                    )
                }
            }
        }
        .opacity(viewModel.showRCONs)
    }
    
    // MARK: - Round Keys View
    private var roundKeyGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(0..<roundKeyGroupCount,
                        id: \.self,
                        content: roundKeySection(for:))
            }
        }
    }
    
    private var roundKeyGroupCount: Int {
        viewModel.showBlockForm
        ? Int(ceil(Double(viewModel.roundKeys.count) / Double(viewModel.keySize.rawValue)))
        : viewModel.roundKeys.count / 4
    }
    
    private func roundKeySection(for groupIndex: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(roundKeyTitle(for: groupIndex))
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(viewModel.showRoundKeyColumn[groupIndex * groupSize])
            
            HStack(spacing: 10) {
                ForEach(0..<groupSize, id: \.self) { row in
                    let index = groupIndex * groupSize + row
                    
                    if index < viewModel.roundKeys.count {
                        ColumnView(column: viewModel.roundKeys[index],
                                   opacity: viewModel.showRoundKeyColumn[index],
                                   highlightColumn: viewModel.highlightColumn[index])
                    }
                }
            }
        }
    }
    
    private var groupSize: Int {
        viewModel.showBlockForm ? viewModel.keySize.rawValue : 4
    }
    
    private func roundKeyTitle(for groupIndex: Int) -> LocalizedStringKey {
        viewModel.showBlockForm
        ? "Schlüsselblock \(groupIndex + 1)"
        : "Rundenschlüssel \(groupIndex + 1)"
    }
    
    // MARK: - Toolbar Item
    private func keyExpRoundsButton() -> some ToolbarContent {
        ToolbarItem {
            HStack {
                if viewModel.keySize.rawValue > 4 {
                    Toggle(isOn: $viewModel.showBlockForm, label: { Text("Zeige Blockform") })
                        .padding(.trailing, padding)
                }
                
                if viewModel.animationControl.isDone {
                    CustomButtonView(title: LocalizedStringKey(buttonTitle),
                                     buttonStyle: .secondary,
                                     action: viewModel.toggleKeyExpRounds)
                    
                }
            }
        }
    }
    
    private var padding: CGFloat {
        #if os(macOS)
        4
        #else
        16
        #endif
    }
}

