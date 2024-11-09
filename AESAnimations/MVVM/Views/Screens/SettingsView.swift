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
    
    // MARK: - Body Content
    var body: some View {
        SheetContainerView(navigationTitle: "Einstellungen") {
            platformSpecificContent
        }
        .alert(isPresented: $viewModel.showAlert, content: alert)
    }
    
    private var platformSpecificContent: some View {
        #if os(macOS)
        VStack(spacing: 20) {
            settingsSections
        }
        #else
        List {
            settingsSections
        }
        #endif
    }
    
    private var settingsSections: some View {
        Group {
            sectionView(title: getTitle(configuration: .language), selectionsView: languageSelections)
            sectionView(title: getTitle(configuration: .appearance), selectionsView: colorSchemeSelections)
            sectionView(title: getTitle(configuration: .color), selectionsView: primaryColorSelection)
            sectionView(title: getTitle(configuration: .others), showDivider: false, selectionsView: furtherSettingsSelections)
        }
    }
    
    // MARK: - Selections Content
    private func languageSelections() -> some View {
        selectionView {
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
    }
    
    private func colorSchemeSelections() -> some View {
        selectionView {
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
    }
    
    private func primaryColorSelection() -> some View {
        selectionView {
            ForEach(PrimaryColor.allCases, id: \.self) { color in
                configurableButton(
                    color: color.color,
                    isSelected: viewModel.primaryColor == color,
                    action: { viewModel.primaryColor = color }
                )
            }
        }
    }
    
    private func furtherSettingsSelections() -> some View {
        selectionView {
            Toggle("Umgekehrte Animations-Option einblenden", isOn: $viewModel.includeReverseAnimation)
        }
    }
    
    // MARK: - Helper Functions
    private func sectionView(title: LocalizedStringKey,
                                   showDivider: Bool = true,
                                   @ViewBuilder selectionsView: () -> some View) -> some View {
        #if os(iOS)
        Section(header: Text(title)) {
            selectionsView()
        }
        #else
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            
            selectionsView()
            
            if showDivider { Divider() }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        #endif
    }
    
    private func selectionView(@ViewBuilder content: () -> some View) -> some View {
        HStack(spacing: 16) {
            content()
        }
        .padding(.all, 5)
    }
    
    // MARK: - Button Helper Functions
    private func configurableButton(color: Color,
                                    isSelected: Bool,
                                    isSystem: Bool = false,
                                    imageName: String? = nil,
                                    action: @escaping () -> Void) -> some View {
        Group {
            if !isSelected {
                Button(action: action) {
                    buttonContent(color: color,
                                  isSelected: isSelected,
                                  isSystem: isSystem,
                                  imageName: imageName)
                }
                .buttonStyle(.plain)
                #if os(iOS)
                .hoverEffect(.lift)
                #endif
            } else {
                buttonContent(color: color,
                              isSelected: isSelected,
                              isSystem: isSystem,
                              imageName: imageName)
            }
        }
    }
    
    private func buttonContent(color: Color,
                               isSelected: Bool,
                               isSystem: Bool,
                               imageName: String? = nil) -> some View {
        let frameSize: CGFloat = isSelected ? 55 : 50
        let overlayFrameSize: CGFloat = isSelected ? 55 : 52
        let overlayColor = isSelected ? viewModel.primaryColor.color : Color.gray.opacity(0.3)
        
        return ZStack {
            if isSystem {
                Circle()
                    .trim(from: 0.5, to: 1.0)
                    .fill(Color.black)
                    .frame(width: frameSize, height: frameSize)
                    .rotationEffect(.degrees(90))
                
                Circle()
                    .trim(from: 0.0, to: 0.5)
                    .fill(Color.white)
                    .frame(width: frameSize, height: frameSize)
                    .rotationEffect(.degrees(90))
            } else if let imageName = imageName {
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
            
            Circle()
                .stroke(overlayColor, lineWidth: 4)
                .frame(width: overlayFrameSize, height: overlayFrameSize)
        }
    }
    
    // MARK: - Alert Function
    private func alert() -> Alert {
        Alert(title: Text(alertTitle),
              message: Text(alertMessage),
              primaryButton: .destructive(Text(alertTitle), action: closeApp),
              secondaryButton: .cancel(Text(cancelTitle)))
    }
    
    private var alertTitle: String {
        viewModel.appLanguage == "de" ? "Neustart" : "Restart"
    }
    
    private var alertMessage: String {
        viewModel.appLanguage == "de"
        ? "Für die Änderung der Sprache wird ein neuer Start der App erforderlich sein."
        : "You will need to restart the app to change the language."
    }
    
    private var cancelTitle: String {
        viewModel.appLanguage == "de" ? "Abbrechen" : "Cancel"
    }
    
    private func closeApp() {
        viewModel.appLanguage = newLanguage
        exit(0)
    }
    
    // MARK: - Title Helper Function
    private func getTitle(configuration: SettingsConfigurations) -> LocalizedStringKey {
        switch configuration {
        case .color:
            return LocalizedStringKey("Wähle Akzentfarbe (\(viewModel.primaryColor.rawValue.capitalized))")
        case .appearance:
            return LocalizedStringKey("Wähle Erscheinungsbild (\(viewModel.colorScheme.rawValue))")
        case .language:
            return LocalizedStringKey("Wähle App-Sprache (\(viewModel.appLanguage.uppercased()))")
        case .others:
            return LocalizedStringKey("Sonstige Einstellungen")
        }
    }
}

