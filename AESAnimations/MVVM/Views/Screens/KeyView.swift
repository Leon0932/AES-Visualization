//
//  KeyView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 30.07.24.
//

import SwiftUI

struct KeyView: View {
    @Environment(\.locale) var locale
    @StateObject var viewModel: KeyViewModel
    
    // MARK: -
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    animateButton
                    keyHeader
                    keysList
                }
                #if os(macOS)
                .frame(maxWidth: .infinity, alignment: .center)
                #endif
            }
            .padding()
            .navigationTitle(locale == Locale(identifier: "de")
                             ? "Generierung der Rundenschlüssel"
                             : "Generation of Round Keys")
            .task { viewModel.animateKeysFunction() }
            #if os(macOS)
            .customNavigationBackButton()
            #endif
        }
    }
    
    // MARK: - Animation Button
    private var animateButton: some View {
        CustomNavigationButton(title: "Schlüssel-Animation ansehen",
                               buttonStyle: SecondaryButtonStyle(font: .headline)) {
            KeyExpansionAnimationView(viewModel: viewModel.keyExpansionViewModel)
        }
        .opacity(viewModel.showButtons)
    }
    
    // MARK: - Header
    private var keyHeader: some View {
        VStack(spacing: 15) {
            Label(
                title: { Text("Schlüssel") },
                icon: { Image(systemName: "key") }
            )
            .fontWeight(.bold)
            
            HStack(spacing: 8) {
                let key = viewModel.aesCipher.key.convertTo1DArray()
                
                if key.count == 32 {
                    VStack(spacing: 10) {
                        keySection(key: key, range: 0..<16)
                        keySection(key: key, range: 16..<32)
                    }
                } else {
                    ForEach(Array(key.enumerated()), id: \.offset) { index, element in
                        Text(String(format: "%02X", element))
                    }
                }
            }
        }
        .fontDesign(.monospaced)
        .font(.title2)
    }
    
    private func keySection(key: [Byte], range: Range<Int>) -> some View {
        HStack(spacing: 8) {
            ForEach(range, id: \.self) { index in
                Text(String(format: "%02X", key[index]))
            }
        }
    }
    
    // MARK: - Round Keys List
    private var keysList: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(viewModel.roundKeys.enumerated()), id: \.offset) { index, key in
                keyRow(index: index, key: key)
            }
        }
    }
    
    @ViewBuilder
    private func keyRow(index: Int, key: [UInt8]) -> some View {
        HStack(alignment: .center, spacing: 24) {
            Text("Rundenschlüssel \(index + 1):")
                .frame(width: 200, alignment: .leading)
                .fontWeight(.semibold)
            
            HStack(spacing: 8) {
                ForEach(Array(key.enumerated()), id: \.offset) { index, element in
                    Text(String(format: "%02X", element))
                        .fontDesign(.monospaced)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .font(.title3)
        .scaleEffect(viewModel.animateKeys[index] ? 1.0 : 0.5)
        .opacity(viewModel.animateKeys[index] ? 1 : 0)
    }
}
