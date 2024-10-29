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
            VStack(spacing: estimateSpacing) {
                modePicker
                matrixViews
                actionButtons
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("Visualisierung von AES")
            .toolbar(content: toolbarItem)
            .sheet(isPresented: $viewModel.showAuthor) { AuthorView() }
            .sheet(isPresented: $viewModel.showSettings) { SettingsView() }
        }
        .onChange(of: viewModel.selectedEncryptionMode) {
            viewModel.handlePickerChange(newValue: $1)
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
            EditableMatrixView(title: "State", icon: "rectangle.split.3x3", matrix: $viewModel.stateMatrix)
            EditableMatrixView(title: "Schlüssel", icon: "key", matrix: $viewModel.keyMatrix)
        }
    }
    
    // MARK: - Button View
    private var actionButtons: some View {
        let isDisabled = !viewModel.stateMatrix.areAllFieldsValid || !viewModel.keyMatrix.areAllFieldsValid
        let primaryStyle = PrimaryButtonStyle(useMaxWidth: true, isDisabled: isDisabled)
        
        return VStack(alignment: .center, spacing: 25) {
            HStack(spacing: 32) {
                CustomNavigationButton(title: "Entschlüsseln", icon: "lock.open", buttonStyle: primaryStyle) {
                    ProcessView(viewModel: viewModel.createProcessViewModel(isDecryption: true))
                }
                
                CustomNavigationButton(title: "Verschlüsseln", icon: "lock",  buttonStyle: primaryStyle) {
                    ProcessView(viewModel: viewModel.createProcessViewModel(isDecryption: false))
                }
            }
            
            CustomButtonView(title: "Urheber der App", buttonStyle: .standard, action: viewModel.toggleAuthor)
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
            CustomButtonView(icon: "gear",
                             buttonStyle: StandardButtonStyle(font: .title2),
                             action: viewModel.toggleSettings)
        }
    }
    
    // MARK: - Computed Properties
    var estimateSpacing: CGFloat {
        #if os(macOS)
        105
        #else
        isPad13Size() ? 120 : 45
        #endif
    }
}


