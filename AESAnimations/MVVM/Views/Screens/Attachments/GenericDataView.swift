//
//  GenericDataView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 29.09.24.
//

import SwiftUI

struct GenericDataView: View {
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Properties
    var navigationTitle: String
    let data: [[Any]]
    let header: [(String, CGFloat)]
    
    @State private var showByteColors: Bool = true
    // MARK: -
    var body: some View {
        NavigationStack {
            List {
                headerRow
                
                ForEach(data.indices, id: \.self) { index in
                    rowForData(data[index])
                }
                
            }
            .navigationTitle(navigationTitle)
            .toolbar(content: switchButton)
            .listStyle(.plain)
            #if os(iOS)
            .toolbar { closeButton { dismiss() } }
            #else
            .customNavigationBackButton()
            #endif
        }
    }
    
    // MARK: - Header Row
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: 0) {
            ForEach(header.indices, id: \.self) { index in
                if index != 0 { Divider() }
                Spacer()
                Text(header[index].0)
                    .fontDesign(.monospaced)
                    .multilineTextAlignment(.center)
                    .frame(width: header[index].1)
                Spacer()
                
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { _ in return 0 }
        .font(.headline)
    }
    
    // MARK: - Row View
    @ViewBuilder
    private func rowForData(_ rowData: [Any]) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<min(rowData.count, header.count),
                    id: \.self) { index in
                
                if index != 0 { Divider() }
                Spacer()
                dataCell(data: rowData[index], width: header[index].1)
                Spacer()
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { _ in return 0 }
    }
    
    // MARK: - Cell View
    @ViewBuilder
    private func dataCell(data: Any, width: CGFloat) -> some View {
        if let text = data as? String {
            Text(text)
                .fontDesign(.monospaced)
                .frame(width: width)
        } else if let number = data as? Int {
            Text("\(number)")
                .fontDesign(.monospaced)
                .frame(width: width)
        } else if let byteArray = data as? [Byte] {
            arrayCell(data: byteArray, width: width)
        } else if let byte2DArray = data as? [[Byte]] {
            VStack(spacing: 10) {
                ForEach(Array(byte2DArray.enumerated()), id: \.offset) { index, array in
                    arrayCell(data: array, width: width)
                }
            }
        } else {
            Text("N/A")
                .frame(width: width)
        }
    }
    
    
    @ViewBuilder
    private func arrayCell(data: [Byte], width: CGFloat) -> some View {
        HStack(spacing: 5) {
            if data.isEmpty {
                placeholderCell
            } else {
                ForEach(0..<min(4, data.count), id: \.self) { index in
                    let data = data[index]
                    
                    CellView(value: data,
                             boxSize: 30,
                             backgroundColor: showByteColors ? .reducedByteColor(data) : .lightGray)
                }
            }
        }
        .frame(width: width)
    }
    
    
    @ViewBuilder
    private var placeholderCell: some View {
        ForEach(0..<4, id: \.self) { _ in
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 30, height: 30)
                .foregroundStyle(.clear)
                .overlay(Rectangle().stroke(Color.clear))
        }
    }
    
    private func switchButton() -> some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            Toggle("Zeige Bunte Farben", isOn: $showByteColors)
        }
    }
}
