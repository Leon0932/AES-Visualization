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
    
    // MARK: - Body Content
    var body: some View {
        SheetContainerView(
            navigationTitle: "Einstellungen",
            toolbarContent: { toolbarButton }
        ) {
            platformSpecificContent
                .sheet(isPresented: $viewModel.showAuthorView, content: AuthorView.init)
        }
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
            #if os(iOS)
            sectionView(title: getTitle(configuration: .color), selectionsView: primaryColorSelection)
            #endif
            sectionView(title: getTitle(configuration: .others), showDivider: false, selectionsView: furtherSettingsSelections)
        }
    }
    
    // MARK: - Selections Content
    private func languageSelections() -> some View {
        selectionView {
            configurableButton(color: .clear,
                               isSelected: viewModel.appLanguage == "de",
                               imageName: "Flag_of_Germany") {
                viewModel.appLanguage = "de"
            }
            
            configurableButton(color: .clear,
                               isSelected: viewModel.appLanguage == "en",
                               imageName: "Flag_of_USA") {
                viewModel.appLanguage = "en"
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
    
    #if os(iOS)
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
    #endif
    
    private func furtherSettingsSelections() -> some View {
        VStack(alignment: .leading,
               spacing: 10) {
            Toggle("Umgekehrte Animations-Option einblenden", isOn: $viewModel.includeReverseAnimation)
            Toggle("Animation bei Anzeige der View automatisch abspielen", isOn: $viewModel.startAnimationOnAppear)
        }
    }
    
    private var toolbarButton: AnyView {
        AnyView(
            CustomToolbarButton(title: "Info",
                                icon: "info.circle",
                                buttonStyle: .standard) {
                viewModel.showAuthorView = true
            }
        )
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
        #if os(iOS)
        let primaryColor = viewModel.primaryColor.color
        #else
        let primaryColor = Color.accentColor
        #endif
        let overlayColor = isSelected ? primaryColor : Color.gray.opacity(0.3)
        
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
    
    // MARK: - Title Helper Function
    private func getTitle(configuration: SettingsConfigurations) -> LocalizedStringKey {
        switch configuration {
        #if os(iOS)
        case .color:
            return LocalizedStringKey("Wähle Akzentfarbe (\(viewModel.primaryColor.rawValue.capitalized))")
        #endif
        case .appearance:
            return LocalizedStringKey("Wähle Erscheinungsbild (\(viewModel.colorScheme.rawValue))")
        case .language:
            return LocalizedStringKey("Wähle App-Sprache (\(viewModel.appLanguage.uppercased()))")
        case .others:
            return LocalizedStringKey("Sonstige Einstellungen")
        }
    }
}

