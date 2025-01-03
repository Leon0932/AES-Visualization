//
//  EditableMatrix.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 28.07.24.
//

import SwiftUI
import Security

/// A matrix of input fields for entering byte values.
/// Includes functionality to generate byte values using the logic from `Matrix` and to remove data as needed.
struct EditableMatrix: View {
    // MARK: - Properties
    let title: LocalizedStringKey
    let icon: String
    @Binding var matrix: Matrix
    
    // MARK: - Computed Properties for View
    var boxSize: CGFloat {
        #if os(iOS)
        DeviceDetector.isPad13Size() ? 100 : 70
        #else
        80
        #endif
    }
    
    var font: Font {
        #if os(iOS)
        DeviceDetector.isPad13Size() ? .title : .title2
        #else
        .title
        #endif
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            headerView
            gridView
            errorText
                .opacity(matrix.containsInvalidInput ? 1 : 0)
        }
        
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            HStack(spacing: 4) {
                Label(title: { Text(title) },
                      icon: { Image(systemName: icon) })
                .font(font)
                
                CustomButtonView(icon: "arrow.uturn.left",
                                 buttonStyle: StandardButtonStyle(font: .title2,
                                                                  isDisabled: matrix.checkNullBytes)) {
                    matrix.fillData()
                }
            }
            
            Spacer()
            
            CustomButtonView(icon: "dice",
                             buttonStyle: SecondaryButtonStyle(font: font)) {
                matrix.generateAndFillRandomBytes()
            }
            
            CustomButtonView(icon: "trash",
                             buttonStyle: SecondaryButtonStyle(font: font)) {
                matrix.clearData()
            }
        }
        .frame(maxWidth: (boxSize + 8) * CGFloat(matrix.columns - 1) + boxSize)
    }
    
    // MARK: - Matrix View
    private var gridView: some View {
        Grid(horizontalSpacing: 8, verticalSpacing: 8) {
            ForEach(0..<matrix.rows, id: \.self) { row in
                GridRow {
                    ForEach(0..<matrix.columns, id: \.self) { column in
                        cellView(row: row, column: column)
                    }
                }
            }
        }
    }
    
    private func cellView(row: Int, column: Int) -> some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor(for: row, column: column), lineWidth: 2)
                .frame(width: boxSize, height: boxSize)
            
            cellEditorView(row: row, column: column)
                .fontDesign(.monospaced)
                .frame(width: boxSize / 2, height: boxSize / 2)
                .multilineTextAlignment(.center)
        }
    }
    
    private func cellEditorView(row: Int, column: Int) -> some View {
        // Validate Input
        let binding = Binding(
            get: { matrix.data[row][column] },
            set: { newValue in
                if newValue.count <= 2 {
                    matrix.data[row][column] = newValue.uppercased()
                    matrix.validateHexInput(row: row, column: column, value: newValue)
                }
            }
        )
        
        return TextField("", text: binding)
            #if os(iOS)
            .padding(4)
            .keyboardType(.asciiCapable)
            .disableAutocorrection(true)
            #else
            .textFieldStyle(PlainTextFieldStyle())
            .focusable(true)
            #endif
    }
    
    // MARK: - Helper Functions
    private func borderColor(for row: Int, column: Int) -> Color {
        matrix.invalidInputFlags[row][column] ? .red : .primary
    }
    
    private var errorText: some View {
        Text("Gültiges Hex-Byte erforderlich (00-FF)")
            .foregroundStyle(.red)
            .font(.title3)
    }
}
