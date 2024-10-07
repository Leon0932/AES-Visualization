//
//  SettingsView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 06.08.24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("selectedColorScheme") private var selectedColorScheme: AppScheme = .device
    @AppStorage("selectedPrimaryColor") private var selectedPrimaryColor: PrimaryColor = .blue
    
    // MARK: -
    var body: some View {
        NavigationStack {
            List {
                colorSchemeSection
                primaryColorSection
            }
            #if os(macOS)
            .preferredColorScheme(selectedColorScheme == .device ? nil : selectedColorScheme == .dark ? .dark : .light)
            #endif
            .navigationTitle("Settings")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { closeButton { dismiss() } }
            #endif   
        }
    }
    
    // MARK: - Color Scheme Selection
    private var colorSchemeSection: some View {
        Section(header: Text("Select Color Scheme (\(selectedColorScheme.rawValue.uppercased()))")) {
            HStack(spacing: 16) {
                configurableButton(
                    title: "System",
                    color: .white,
                    isSelected: selectedColorScheme == .device,
                    isSystem: true,
                    action: { selectedColorScheme = .device })
                
                configurableButton(
                    title: "Light",
                    color: .white,
                    isSelected: selectedColorScheme == .light,
                    action: { selectedColorScheme = .light }
                )
                configurableButton(
                    title: "Dark",
                    color: .black,
                    isSelected: selectedColorScheme == .dark,
                    action: { selectedColorScheme = .dark }
                )
            }
            .padding()
        }
    }
    
    // MARK: - Primary Color Selection
    private var primaryColorSection: some View {
        Section(header: Text("Select Primary Color (\(selectedPrimaryColor.rawValue.uppercased()))")) {
            HStack(spacing: 16) {
                ForEach(PrimaryColor.allCases, id: \.self) { color in
                    configurableButton(
                        title: color.rawValue.capitalized,
                        color: color.color,
                        isSelected: selectedPrimaryColor == color,
                        action: { selectedPrimaryColor = color }
                    )
                }
            }
            .padding()
        }
    }
    
    // MARK: - Helper Functions
    private func configurableButton(title: String,
                                    color: Color,
                                    isSelected: Bool,
                                    isSystem: Bool = false,
                                    action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                if isSystem {
                    Circle()
                        .trim(from: 0.5, to: 1.0)
                        .fill(Color.black)
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(90))
                    
                    Circle()
                        .trim(from: 0.0, to: 0.5)
                        .fill(Color.white)
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(90))
                } else {
                    Circle()
                        .fill(color)
                        .frame(width: 50, height: 50)
                        .scaleEffect(isSelected ? 0.95 : 1.0)
                }
                
                
                Circle()
                    .stroke(isSelected ? selectedPrimaryColor.color : Color.gray.opacity(0.3),
                            lineWidth: 4)
                    .frame(width: isSelected ? 55 : 52,
                           height: isSelected ? 55 : 52)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(Text(title))
    }
}
