//
//  EditableMatrixView.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 28.07.24.
//

import SwiftUI
import Security

struct EditableMatrixView: View {
    // MARK: - Properties
    let titleLabel: String
    let iconLabel: String
    let buttonTitle: String
    @Binding var matrix: Matrix
    
    // MARK: -
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
        HStack(spacing: 24) {
            Label(title: { Text(titleLabel) }, icon: { Image(systemName: iconLabel) })
                .font(.title)
            Button {
                matrix.generateAndFillRandomBytes()
            } label: {
                Image(systemName: "dice")
                    .font(.title)
            }
            .buttonStyle(BorderedButtonStyle())
        }
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
                .frame(width: 80, height: 80)
            
            cellEditorView(row: row, column: column)
                .fontDesign(.monospaced)
                .frame(width: 40, height: 40)
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    private func cellEditorView(row: Int, column: Int) -> some View {
        let binding = Binding(
            get: { matrix.data[row][column] },
            set: { newValue in
                if newValue.count <= 2 {
                    matrix.data[row][column] = newValue.uppercased()
                    matrix.validateHexInput(row: row, column: column, value: newValue)
                }
            }
        )
        
        #if os(iOS)
        TextField("", text: binding)
            .padding(4)
            .keyboardType(.asciiCapable)
           
 
        #else
        TextField("", text: binding)
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
            .foregroundColor(.red)
            .font(.title3)
    }
}
