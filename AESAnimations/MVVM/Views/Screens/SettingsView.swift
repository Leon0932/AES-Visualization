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
    
    @State private var newLanguage = ""
    
    // MARK: -
    var body: some View {
        SheetContainerView(navigationTitle: "Einstellungen") {
            #if os(macOS)
            VStack(spacing: 20) {
                languageSectionMac
                colorSchemeSectionMac
                primaryColorSectionMac
                furtherSettingsSectionMac
            }
            #else
            List {
                languageSection
                colorSchemeSection
                primaryColorSection
                furtherSettingsSection
            }
            #endif
        }
        .alert(isPresented: $viewModel.showAlert, content: alert)
    }
    
    // MARK: - Language Selection
    private var languageSection: some View {
        Section(header: Text(getTitle(configuration: .language))) {
            languageSelections
        }
    }
    
    private var languageSelections: some View {
        HStack(spacing: 16) {
            configurableButton(color: .clear,
                               isSelected: viewModel.appLanguage == "de",
                               imageName: "Flag_of_Germany") {
                newLanguage = "de"
                viewModel.showAlert = true
            }
            
            configurableButton(color: .clear,
                               isSelected: viewModel.appLanguage == "en",
                               imageName: "Flag_of_USA") {
                newLanguage = "en"
                viewModel.showAlert = true
            }
        }
        .padding(.all, 5)
    }

    private var languageSectionMac: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(getTitle(configuration: .language))
                .font(.headline)
            
            languageSelections
            
            Divider()
        }
    }
    
    // MARK: - Color Scheme Selection
    private var colorSchemeSection: some View {
        Section(header: Text(getTitle(configuration: .appearance))) {
            colorSchemeSelections
        }
    }
    
    private var colorSchemeSectionMac: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(getTitle(configuration: .appearance))
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
        .padding(.all, 5)
    }
    
    // MARK: - Primary Color Selection
    private var primaryColorSection: some View {
        Section(header: Text(getTitle(configuration: .color))) {
            primaryColorSelections
        }
    }
    
    private var primaryColorSectionMac: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(getTitle(configuration: .color))
                .font(.headline)
            
            primaryColorSelections
            
            Divider()
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
        .padding(.all, 5)
    }
    
    // MARK: - Extra Settings
    private var furtherSettingsSection: some View {
        Section(header: Text("Sonstige Einstellungen")) {
            furtherSettingsSelections
        }
    }
    
    private var furtherSettingsSectionMac: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Sonstige Einstellungen")
                .font(.headline)
            
            furtherSettingsSelections
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var furtherSettingsSelections: some View {
        VStack(alignment: .leading, spacing: 10) {
            Toggle("Umgekehrte Animations-Option einblenden", isOn: $viewModel.includeReverseAnimation)
        }
        .padding(.all, 5)
    }
    
    // MARK: - Helper Functions
    private func configurableButton(color: Color,
                                    isSelected: Bool,
                                    isSystem: Bool = false,
                                    imageName: String? = nil,
                                    action: @escaping () -> Void) -> some View {
        if !isSelected {
            return Button(action: action) {
                buttonContent(color: color, isSelected: isSelected, isSystem: isSystem, imageName: imageName)
            }
            .buttonStyle(.plain)
            #if os(iOS)
            .hoverEffect(.lift)
            #endif
        } else {
            return buttonContent(color: color, isSelected: isSelected, isSystem: isSystem, imageName: imageName)
        }
    }
    
    private func buttonContent(color: Color,
                               isSelected: Bool,
                               isSystem: Bool,
                               imageName: String? = nil) -> some View {
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
                if let imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .scaleEffect(isSelected ? 0.95 : 1.0)
                } else {
                    Circle()
                        .fill(color)
                        .frame(width: 50, height: 50)
                        .scaleEffect(isSelected ? 0.95 : 1.0)
                }
            }
            
            Circle()
                .stroke(isSelected ? viewModel.primaryColor.color : Color.gray.opacity(0.3),
                        lineWidth: 4)
                .frame(width: selectedFrame, height: selectedFrame)
        }
    }
    
    private func getTitle(configuration: SettingsConfigurations) -> LocalizedStringKey {
        switch configuration {
        case .color:
            return LocalizedStringKey("Wähle Akzentfarbe (\(viewModel.primaryColor.rawValue.capitalized))")
        case .appearance:
            return LocalizedStringKey("Wähle Erscheinungsbild (\(viewModel.colorScheme.rawValue))")
        case .language:
            return LocalizedStringKey("Wähle App-Sprache (\(viewModel.appLanguage.uppercased()))")
        }
    }
    
    private func alert() -> Alert {
        Alert(title: Text("Neustart"),
              message: Text("Für die Änderung der Sprache wird ein neuer Start der App erforderlich sein."),
              primaryButton: .destructive(Text("Neustart"), action: closeApp),
              secondaryButton: .cancel())
    }
    
    private func closeApp() {
        viewModel.appLanguage = newLanguage
        exit(0)
    }
}
