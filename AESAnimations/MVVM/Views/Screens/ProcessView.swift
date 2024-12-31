//
//  ProcessView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 30.07.24.
//

import SwiftUI

struct ProcessView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.locale) var locale
    
    @StateObject var viewModel: ProcessViewModel
    @EnvironmentObject var settingsVM: SettingsViewModel
    
    var boxSize: CGFloat {
        #if os(iOS)
        DeviceDetector.isPad13Size() ? 50 : 45
        #else
        50
        #endif
    }
    
    var matrixWidth: CGFloat {
        (boxSize + LayoutStyles.spacingMatrix) * 3 + boxSize
    }
    
    // MARK: -
    var body: some View {
        AnimationContainerView(viewModel: viewModel, showReverseAnimationButton: false) {
            HStack {
                buildStateColumn(leftColumn: true)
                Spacer()
                buildCenterColumn
                    .padding(.bottom, 65)
                Spacer()
                buildStateColumn(leftColumn: false)
            }
        }
        .toolbar(content: cipherHistoryButton)
        .navigationDestination(isPresented: $viewModel.showAnimationView,
                               destination: destinationView)
        .onDisappear { viewModel.animationControl.changePause(to: true) }
        .specificNavigation(isPresented: $viewModel.showCipherHistory,
                            destination: createCipherHistory)
        .sheet(isPresented: $viewModel.showFullKey, content: sheetView)
    }
    
    // MARK: - State Columns
    private func buildStateColumn(leftColumn: Bool) -> some View {
        VStack(spacing: 25) {
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    StateTitle(title: leftColumn
                               ? "Start-Zustand"
                               : (viewModel.animationControl.isDone ? "Ergebnis" : "Aktueller Zustand"))
                    
                    Spacer()
                    
                    if !leftColumn && viewModel.animationControl.isDone && viewModel.showCipherButton {
                        CustomNavigationButton(title: viewModel.operationDetails.isInverseMode
                                               ? "Verschlüsseln"
                                               : "Entschlüsseln",
                                               buttonStyle: StandardButtonStyle(font: TextStyles.headline)) {
                            ProcessView(viewModel: viewModel.nextProcessViewModel)
                        }
                        
                    }
                }
                .frame(width: matrixWidth, height: 10)
                
                StateView(state: leftColumn ? viewModel.state : viewModel.currentState,
                          boxSize: boxSize)
            }
            
            if leftColumn {
                if viewModel.nk > 4 {
                    keyButton
                } else {
                    keyView(title: keyTitle)
                }
            } else {
                StateView(
                    title: "Rundenschlüssel \(viewModel.currentRoundKeyNumber)",
                    state: viewModel.currentRoundKey,
                    boxSize: boxSize,
                    alignment: .leading
                )
                .opacity(viewModel.showRoundKeyColumn)
            }
        }
    }
    
    private func keyView(title: LocalizedStringKey? = nil) -> some View {
        StateView(title: title,
                  state: viewModel.key,
                  boxSize: boxSize,
                  alignment: .leading
        )
    }
    
    private var keyButton: some View {
        HStack {
            Text(keyTitle)
            
            Spacer()
            
            CustomButtonView(icon: "arrow.up.left.and.arrow.down.right",
                             buttonStyle: StandardButtonStyle(font: .title2),
                             action: viewModel.toggleFullKey)
        }
        .font(TextStyles.headline)
        .frame(width: 230, height: 250, alignment: .topLeading)
    }
    
    // MARK: - Center Column with Animation and Rounds
    private var buildCenterColumn: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 25) {
                roundView(phase: 0)
                    .frame(maxWidth: .infinity)
                
                
                roundView(phase: 1, data: viewModel.phaseOne)
                    .frame(maxWidth: .infinity)
                
                
                roundView(phase: 2, data: viewModel.phaseTwo)
                    .background(
                        HorizontalLine(mainRounds: viewModel.rounds,
                                       currentRound: $viewModel.currentRoundNumber)
                    )
                
                
                roundView(phase: 3, data: viewModel.phaseThree)
                    .frame(maxWidth: .infinity)
                
            }
            .padding(.vertical, 10)
            .background(VerticalLine(horizontalLineHeight: $viewModel.horizontalLineHeight))
            .frame(maxWidth: 450, alignment: .center)
            
            Circle()
                .frame(width: 20, height: 20)
                .offset(x: viewModel.ballPositionX, y: viewModel.ballPosition)
                .foregroundStyle(Color.accentColor)
                .zIndex(checkHighlight ? -1 : 0)
            
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
                             color: (viewModel.highlightOperation[phase]?[0] == true)
                             ? .blue
                             : .blue.opacity(0.5))
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
    private func subRoundStepView(phase: Int,
                                  currentPosition: Int,
                                  text: String,
                                  keyPath: KeyPath<CipherRound, [[Byte]]>,
                                  color: Color) -> some View {
        if viewModel.highlightOperation[phase]?[currentPosition] == true {
            Button {
                viewModel.selectedKeyPath = keyPath
                viewModel.showAnimationView = true
            } label: {
                operationRectangleView(text: text, color: color)
            }
            #if os(macOS)
            .buttonStyle(.plain)
            #else
            .hoverEffect(.lift)
            #endif
        } else {
            operationRectangleView(text: text, color: color)
        }
    }
    
    private func operationRectangleView(text: String, color: Color) -> some View {
        ZStack {
            Rectangle()
                .fill(getColorForRectangle())
                .frame(width: 2, height: 40)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .frame(width: 200, height: 40)
                .overlay(
                    Text(text)
                        .foregroundStyle(.white)
                )
                .padding(.vertical, 5)
        }
    }
    
    private func getColorForRectangle() -> Color {
        #if os(macOS)
        colorScheme == .dark ? Color.darkModeMac : Color.lightModeMac
        #else
        colorScheme == .dark ? .black : .white
        #endif
    }
    
    // MARK: - Sheet View
    private func sheetView() -> some View {
        SheetContainerView(navigationTitle: keyTitle) {
            keyView()
        }
    }
    
    // MARK: - Helper functions
    @ViewBuilder
    private func destinationView() -> some View {
        switch viewModel.selectedKeyPath {
        case \.roundKey:        KeyView(viewModel: viewModel.keyViewModel)
        case \.afterAddRound:   AddRoundKeyAnimationView(viewModel: viewModel.addRoundKeyViewModel)
        case \.afterSubBytes:   SubBytesAnimationView(viewModel: viewModel.subBytesViewModel)
        case \.afterShiftRows:  ShiftRowsAnimationView(viewModel: viewModel.shiftRowsViewModel)
        case \.afterMixColumns: MixColumnAnimationView(viewModel: viewModel.mixColumnsViewModel)
            
        default:
            Text("Die Operation existiert nicht")
        }
    }
    
    private func cipherHistoryButton() -> some ToolbarContent {
        ToolbarItem {
            CustomButtonView(title: LocalizedStringKey(sheetTitle),
                             buttonStyle: .secondary,
                             action: viewModel.toggleCipherHistory)
            .opacity(viewModel.animationControl.isDone ? 1 : 0)
        }
    }
    
    private var keyTitle: LocalizedStringKey { "Schlüssel (\(viewModel.nk * 32)-Bit)" }
    
    var sheetTitle: String {
        if viewModel.operationDetails.isInverseMode {
            locale == Locale(identifier: "de") ? "Entschlüsselungs-Verlauf" : "Decryption History"
        } else {
            locale == Locale(identifier: "de") ? "Verschlüsselungs-Verlauf" : "Encryption History"
        }
    }
    
    func createCipherHistory() -> some View {
        CipherHistory(navigationTitle: sheetTitle,
                      cipherRounds: viewModel.cipherHistory,
                      isDecryption: viewModel.operationDetails.isInverseMode)
    }
    
    
    private var checkHighlight: Bool {
        viewModel.highlightOperation.values.contains { $0.contains(true) }
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
                        
                        CellView(value: Byte(currentRound),
                                 boxSize: 50,
                                 backgroundColor: .lightGray,
                                 valueFormat: .number)
                    }
                    .position(x: geometry.size.width / 2 - 200,
                              y: geometry.size.height / 2)
                }
            }
        }
    }
}
