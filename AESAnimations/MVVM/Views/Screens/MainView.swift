//
//  ContentView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 06.07.24.
//

import SwiftUI
import TipKit

struct MainView: View {
    @Environment(\.openWindow) var openWindow
    
    @StateObject var viewModel = MainViewModel()
    // MARK: -
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: estimateSpacing) {
                    modePicker
                    matrixViews
                    actionButtons
                }
                .padding()
                .navigationTitle("Visualisierung von AES")
                .toolbar(content: toolbarItem)
                .sheet(isPresented: $viewModel.showAuthor) { AuthorView() }
                #if os(iOS)
                .sheet(isPresented: $viewModel.showSettings) { SettingsView() }
                #endif
                
            }
        }
        .onChange(of: viewModel.selectedEncryptionMode) {
            viewModel.handleEncryptionModeChange(newValue: $1)
        }
    }
    
    // MARK: - Encryption Mode Selection
    private var modePicker: some View {
        VStack {
            Picker("", selection: $viewModel.selectedEncryptionMode) {
                ForEach(EncryptionMode.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
        }
    }
    
    // MARK: - State and Key View
    private var matrixViews: some View {
        HStack(spacing: 40) {
            EditableMatrixView(titleLabel: "State",
                               iconLabel: "rectangle.split.3x3",
                               buttonTitle: "Generate Random-State",
                               matrix: $viewModel.stateMatrix)
            
            EditableMatrixView(titleLabel: "Schlüssel",
                               iconLabel: "key",
                               buttonTitle: "Generate Random-Key",
                               matrix: $viewModel.keyMatrix)
        }
    }
    
    // MARK: - Button View
    private var actionButtons: some View {
        VStack(alignment: .center, spacing: 25) {
            HStack(spacing: 32) {
                
                CustomButton(
                    title: "Entschlüsseln",
                    icon: "lock.open",
                    isDisabled: !viewModel.stateMatrix.areAllFieldsValid || !viewModel.keyMatrix.areAllFieldsValid,
                    destination: {
                        ProcessView(viewModel: viewModel.createProcessViewModel(isDecryption: true))
                    },
                    action: {}
                )
                
                CustomButton(
                    title: "Verschlüsseln",
                    icon: "lock",
                    isDisabled: !viewModel.stateMatrix.areAllFieldsValid || !viewModel.keyMatrix.areAllFieldsValid,
                    destination: {
                        ProcessView(viewModel: viewModel.createProcessViewModel(isDecryption: false))
                    },
                    action: {}
                )
            }
            .padding(.horizontal, 50)
            
            Button {
                viewModel.showAuthor.toggle()
            } label: {
                Text("Urheber der App")
                    .font(.headline)
                    .foregroundColor(.accentColor)
            }
            #if os(macOS)
            .buttonStyle(.plain)
            #endif
        }
    }
    
    // MARK: - Toolbar Item
    private func toolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: {
            #if os(iOS)
            .topBarTrailing
            #else
            .automatic
            #endif
        }()) {
            Button(action: toggleSettings) {
                Image(systemName: "gear")
            }
        }
    }
    
    // MARK: - Helper Functions / Computed Properties
    private func toggleSettings() {
        #if os(iOS)
        viewModel.showSettings.toggle()
        #else
        openWindow(id: "settings")
        #endif
    }
    
    var estimateSpacing: CGFloat {
        #if os(macOS)
        120
        #else
        isPad13Size() ? 120 : 45
        #endif
    }
}


