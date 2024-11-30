//
//  ContentView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 06.07.24.
//

import SwiftUI

struct MainView: View {
    @Environment(\.locale) var locale
    @StateObject var viewModel = MainViewModel()
    
    // MARK: - Body
    var body: some View {
        if viewModel.showMainView {
            mainView
        } else {
            WelcomeView(showMainView: $viewModel.showMainView,
                        showSafariView: $viewModel.showSafariView)
        }
    }
    
    // MARK: - Main View
    var mainView: some View {
        NavigationStack {
            mainContent
                .navigationTitle(locale == Locale(identifier: "de") ? "Visualisierung von AES" : "Visualization of AES")
                .toolbar(content: toolbarItem)
                .onChange(of: viewModel.selectedEncryptionMode) {
                    viewModel.handlePickerChange(newValue: $1)
                }
                .sheet(isPresented: $viewModel.showAuthor, content: AuthorView.init)
                .sheet(isPresented: $viewModel.showSettings, content: SettingsView.init)
        }
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        VStack(spacing: estimateSpacing) {
            modePicker
            matrixViews
            actionButtons
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
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
            EditableMatrixView(title: "Zustand", icon: "rectangle.split.3x3", matrix: $viewModel.stateMatrix)
            EditableMatrixView(title: "Schlüssel", icon: "key", matrix: $viewModel.keyMatrix)
        }
    }
    
    // MARK: - Button View
    private var actionButtons: some View {
        let isDisabled = !viewModel.stateMatrix.areAllFieldsValid || !viewModel.keyMatrix.areAllFieldsValid
        let primaryStyle = PrimaryButtonStyle(useMaxWidth: true, isDisabled: isDisabled)
        
        return HStack(spacing: 32) {
            CustomNavigationButton(title: "Verschlüsseln", icon: "lock",  buttonStyle: primaryStyle) {
                ProcessView(viewModel: viewModel.createProcessViewModel(isDecryption: false))
            }
            
            CustomNavigationButton(title: "Entschlüsseln", icon: "lock.open", buttonStyle: primaryStyle) {
                ProcessView(viewModel: viewModel.createProcessViewModel(isDecryption: true))
            }
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
        isPad13Size() ? 140 : 45
        #endif
    }
}


