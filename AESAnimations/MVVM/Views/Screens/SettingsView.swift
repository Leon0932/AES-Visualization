//
//  SettingsView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 06.08.24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: SettingsViewModel
    
    // MARK: -
    var body: some View {
        SheetContainerView(navigationTitle: "Einstellungen") {
            #if os(macOS)
            VStack(spacing: 20) {
                colorSchemeSectionMac
                primaryColorSectionMac
            }
            #else
            List {
                colorSchemeSection
                primaryColorSection
            }
            #endif
        }
    }
    
    // MARK: - Color Scheme Selection
    private var colorSchemeSection: some View {
        Section(header: Text(getTitle(isColor: false))) {
            colorSchemeSelections
        }
    }
    
    private var colorSchemeSectionMac: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(getTitle(isColor: false))
                .font(.headline)
            
            colorSchemeSelections
            
            Divider()
        }
    }
    
    private var colorSchemeSelections: some View {
        HStack(spacing: 16) {
            configurableButton(
                color: .white,
                isSelected: viewModel.colorScheme == .system,
                isSystem: true,
                action: { viewModel.colorScheme = .system })
            
            configurableButton(
                color: .white,
                isSelected: viewModel.colorScheme == .light,
                action: { viewModel.colorScheme = .light }
            )
            configurableButton(
                color: .black,
                isSelected: viewModel.colorScheme == .dark,
                action: { viewModel.colorScheme = .dark }
            )
        }
        .padding()
    }
    
    // MARK: - Primary Color Selection
    private var primaryColorSection: some View {
        Section(header: Text(getTitle(isColor: true))) {
            primaryColorSelections
        }
    }
    
    private var primaryColorSectionMac: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(getTitle(isColor: true))
                .font(.headline)
            
            primaryColorSelections
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var primaryColorSelections: some View {
        HStack(spacing: 16) {
            ForEach(PrimaryColor.allCases, id: \.self) { color in
                configurableButton(
                    color: color.color,
                    isSelected: viewModel.primaryColor == color,
                    action: { viewModel.primaryColor = color }
                )
            }
        }
        .padding()
    }
    
    // MARK: - Helper Functions
    private func configurableButton(color: Color,
                                    isSelected: Bool,
                                    isSystem: Bool = false,
                                    action: @escaping () -> Void) -> some View {
        if !isSelected {
            return Button(action: action) {
                buttonContent(color: color, isSelected: isSelected, isSystem: isSystem)
            }
            .buttonStyle(.plain)
            #if os(iOS)
            .hoverEffect(.lift)
            #endif
        } else {
            return buttonContent(color: color, isSelected: isSelected, isSystem: isSystem)
        }
    }
    
    private func buttonContent(color: Color,
                               isSelected: Bool,
                               isSystem: Bool) -> some View {
        let frame = 50.0
        let degrees = 90.0
        let selectedFrame = isSelected ? 55.0 : 52.0
        
        return ZStack {
            if isSystem {
                Circle()
                    .trim(from: 0.5, to: 1.0)
                    .fill(Color.black)
                    .frame(width: frame, height: frame)
                    .rotationEffect(.degrees(degrees))
                
                Circle()
                    .trim(from: 0.0, to: 0.5)
                    .fill(Color.white)
                    .frame(width: frame, height: frame)
                    .rotationEffect(.degrees(degrees))
            } else {
                Circle()
                    .fill(color)
                    .frame(width: 50, height: 50)
                    .scaleEffect(isSelected ? 0.95 : 1.0)
            }
            
            
            Circle()
                .stroke(isSelected ? viewModel.primaryColor.color : Color.gray.opacity(0.3),
                        lineWidth: 4)
                .frame(width: selectedFrame, height: selectedFrame)
        }
    }
    
    private func getTitle(isColor: Bool) -> String {
        "Wähle \(!isColor ? "Erscheinungsbild (\(viewModel.colorScheme.rawValue))" : "Akzentfarbe (\(viewModel.primaryColor.rawValue.capitalized))")"
    }
}
