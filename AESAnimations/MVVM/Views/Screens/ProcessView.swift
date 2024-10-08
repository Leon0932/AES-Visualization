//
//  ProcessView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 30.07.24.
//

import SwiftUI

struct ProcessView: View {
    @StateObject var viewModel: ProcessViewModel
    @AppStorage("selectedPrimaryColor") private var selectedPrimaryColor: PrimaryColor = .blue
    
    // MARK: -
    var body: some View {
        AnimationContainerView(viewModel: viewModel) {
            HStack {
                buildStateColumn(leftColumn: true)
                Spacer()
                buildCenterColumn()
                Spacer()
                buildStateColumn(leftColumn: false)
            }
            .padding()
        }
        .toolbar(content: cipherHistoryButton)
        .navigationDestination(isPresented: $viewModel.showAnimationView) { destinationView }
        .onDisappear { viewModel.animationControl.changePause(to: true) }
        .platformSpecificNavigation(isPresented: $viewModel.showCipherHistory) {
            CipherHistoryView(cipherRounds: viewModel.cipherHistory,
                              isDecryption: viewModel.operationDetails.isInverseMode)
        }
        .sheet(isPresented: $viewModel.showFullKey, content: sheetView)
    }
    
    // MARK: - Toolbar
    private func cipherHistoryButton() -> some ToolbarContent {
        ToolbarItem {
            Button("Zeige Gesamten Verlauf") { viewModel.showCipherHistory.toggle() }
                .buttonStyle(BorderedButtonStyle())
                .opacity(viewModel.animationControl.isDone ? 1 : 0)
        }
    }
    
    // MARK: - State Columns
    private func buildStateColumn(leftColumn: Bool) -> some View {
        VStack(spacing: 25) {
            if leftColumn {
                StateView(
                    title: "Start-State",
                    state: viewModel.state,
                    backgroundColor: .reducedAccentColor,
                    alignment: .leading
                )
                keyMatrixView(showFourColumns: true)
                    .onTapGesture {
                        viewModel.showFullKey.toggle()
                    }
            } else {
                StateView(
                    title: viewModel.animationControl.isDone ? "Ergebnis" : "Aktueller State",
                    state: viewModel.currentState,
                    backgroundColor: .reducedAccentColor,
                    alignment: .leading
                )
                StateView(
                    title: "Rundenschlüssel \(viewModel.currentRoundNumber)",
                    state: viewModel.currentRoundKey,
                    backgroundColor: .reducedAccentColor,
                    alignment: .leading
                )
                .opacity(viewModel.showRoundKeyColumn)
                
            }
        }
    }
    
    // MARK: - Center Column with Animation and Rounds
    private func buildCenterColumn() -> some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 25) {
                roundView(phase: 0)
                    .frame(maxWidth: .infinity)
                
                roundView(phase: 1, data: viewModel.phaseOne)
                    .frame(maxWidth: .infinity)
                
                roundView(phase: 2, data: viewModel.phaseTwo)
                    .background(HorizontalLine(mainRounds: viewModel.aesCipher.nrOfRounds,
                                               currentRound: $viewModel.currentRoundNumber))
                
                roundView(phase: 3, data: viewModel.phaseThree)
                    .frame(maxWidth: .infinity)
            }
            .zIndex(1)
            .padding(.vertical, 10)
            .background(VerticalLine(horizontalLineHeight: $viewModel.horizontalLineHeight))
            .frame(maxWidth: 450, alignment: .center)
            
            Circle()
                .frame(width: 20, height: 20)
                .offset(x: viewModel.ballPositionX, y: viewModel.ballPosition)
                .foregroundColor(.accentColor)
            
        }
    }
    
    // MARK: - Round View
    @ViewBuilder
    private func roundView(phase: Int, data: [ProcessPhaseAnimation] = []) -> some View {
        if data.isEmpty {
            subRoundStepView(phase: 0,
                             currentPosition: 0,
                             text: "KeyExpansion",
                             keyPath: \.roundKey,
                             color: (viewModel.highlightOperation[phase]?[0] == true) ? .blue : .blue.opacity(0.5))
        } else {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(data.enumerated()), id: \.0) { i, element in
                    subRoundStepView(
                        phase: phase,
                        currentPosition: i,
                        text: element.operation,
                        keyPath: element.keyPath,
                        color: (viewModel.highlightOperation[phase]?[i] == true) ? element.color : element.color.opacity(0.5)
                    )
                }
            }
        }
    }
    
    // MARK: - Sub Round Step View
    @ViewBuilder
    private func subRoundStepView(phase: Int, currentPosition: Int, text: String, keyPath: KeyPath<CipherRound, [[Byte]]>, color: Color) -> some View {
        if viewModel.highlightOperation[phase]?[currentPosition] == true {
            Button {
                viewModel.selectedKeyPath = keyPath
                viewModel.showAnimationView = true
            } label: {
                operationRectangleView(text: text, color: color)
            }
            #if os(macOS)
            .buttonStyle(.plain)
            #endif
        } else {
            operationRectangleView(text: text, color: color)
        }
    }
    
    private func operationRectangleView(text: String, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(color)
            .frame(width: 200, height: 40)
            .overlay(
                Text(text)
                    .foregroundColor(.white)
            )
            .padding(.vertical, 5)
    }
    
    // MARK: - Sheet View
    private func sheetView() -> some View {
        VStack(alignment: .center, spacing: 25) {
            keyMatrixView(showFourColumns: false)
            
            CustomButton<Never>(title: "Close", useMaxWidth: false) {
                viewModel.showFullKey.toggle()
            }
        }
        .padding(20)
        .accentColor(selectedPrimaryColor.color)
    }
    
    // MARK: - Helper functions
    @ViewBuilder
    var destinationView: some View {
        switch viewModel.selectedKeyPath {
        case \.roundKey:
            KeyView(viewModel: viewModel.keyViewModel)
        case \.afterAddRound:
            AddRoundKeyAnimationView(viewModel: viewModel.addRoundKeyViewModel)
        case \.afterSubBytes:
            SubBytesAnimationView(viewModel: viewModel.subBytesViewModel)
        case \.afterShiftRows:
            ShiftRowsAnimationView(viewModel: viewModel.shiftRowsViewModel)
        case \.afterMixColumns:
            MixColumnAnimationView(viewModel: viewModel.mixColumnsViewModel)
            
        default:
            Text("Hi")
        }
    }
    
    func keyMatrixView(showFourColumns: Bool) -> some View {
        StateView(
            title: "Schlüssel (\(viewModel.aesCipher.keySize * 32)-Bit)",
            state: viewModel.key,
            backgroundColor: .reducedAccentColor,
            alignment: .leading,
            showFourColumns: showFourColumns
        )
    }
}

// MARK: - Draw Lines
extension ProcessView {
    struct VerticalLine: View {
        @Binding var horizontalLineHeight: CGFloat
        
        var body: some View {
            GeometryReader { geometry in
                Path { path in
                    
                    let midX = geometry.size.width / 2
                    path.move(to: CGPoint(x: midX, y: 0))
                    path.addLine(to: CGPoint(x: midX, y: geometry.size.height))
                }
                .stroke(Color.primary.opacity(0.6), lineWidth: 2)
                .onAppear { horizontalLineHeight = geometry.size.height }
                .zIndex(0)
            }
            
        }
    }
    
    struct HorizontalLine: View {
        let mainRounds: Int
        @Binding var currentRound: Int
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Path { path in
                        let midX = geometry.size.width / 2
                        let height = geometry.size.height + 10
                        
                        // Draw horizontal and vertical lines
                        path.move(to: CGPoint(x: midX, y: height))
                        path.addLine(to: CGPoint(x: midX + 125, y: height))
                        path.addLine(to: CGPoint(x: midX + 125, y: -10))
                        path.addLine(to: CGPoint(x: midX, y: -10))
                        
                        // Arrow drawing
                        path.addLine(to: CGPoint(x: midX + 10, y: 0))
                        path.addLine(to: CGPoint(x: midX, y: -10))
                        path.addLine(to: CGPoint(x: midX + 10, y: -20))
                    }
                    .stroke(Color.primary.opacity(0.6), lineWidth: 2)
                    .zIndex(0)
                    
                    // Hauptrunden
                    VStack(alignment: .center, spacing: 8) {
                        Text("Hauptrunden:")
                            .font(.headline)
                        
                        CellView(value: Byte(mainRounds - 1),
                                 boxSize: 50,
                                 backgroundColor: .lightGray,
                                 valueFormat: .number)
                    }
                    .position(x: geometry.size.width / 2 + 200, y: geometry.size.height / 2)
                    
                    // Aktuelle Runde
                    VStack(alignment: .center, spacing: 8) {
                        Text("Aktuelle Runde:")
                            .font(.headline)
                        
                        CellView(value: Byte(currentRound), boxSize: 50, backgroundColor: .lightGray, valueFormat: .number)
                    }
                    .position(x: geometry.size.width / 2 - 200, y: geometry.size.height / 2)
                }
            }
        }
    }
}
