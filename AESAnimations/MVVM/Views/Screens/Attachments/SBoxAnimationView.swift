//
//  SBoxAnimationView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 15.10.24.
//

import SwiftUI

struct SBoxAnimationView: View {
    @StateObject var viewModel: SBoxAnimationViewModel
    @Environment(\.dismiss) var dismiss
    
    // MARK: -
    var body: some View {
        AnimationContainerView(viewModel: viewModel) {
            VStack(spacing: 25) {
                byteDisplaySection
                
                HStack {
                    affineTransformationSection
                    
                    Spacer()
                    
                    SBoxView(searchResult: .constant(nil),
                             isInverseMode: viewModel.operationDetails.isInverseMode,
                             opacityOfValues: viewModel.opacityOfSBox)
                }
            }
            #if os(iOS)
            .toolbar { closeButton { dismiss() } }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            #else
            .customNavigationBackButton()
            #endif
        }
    }
    
    // MARK: - Byte Display Section
    private var byteDisplaySection: some View {
        HStack(spacing: 50) {
            byteCell(title: "Aktuelles Byte",
                     value: viewModel.currentByte,
                     opacity: viewModel.showCurrentByte)
            
            byteCell(title: "Multiplikates Inverses",
                     value: viewModel.currentMultInv,
                     opacity: viewModel.showCurrentMultInv)
            
            byteCell(title: "Ergebnis",
                     value: viewModel.resultSBox,
                     opacity: viewModel.showResultSBox)
        }
    }
    
    private func byteCell(title: String, value: Byte, opacity: Double) -> some View {
        VStack(alignment: .center, spacing: 10) {
            Text(title)
            CellView(value: value, boxSize: 35, backgroundColor: .lightGray)
        }
        .opacity(opacity)
    }
    
    // MARK: - Affine Transformation Section
    private var affineTransformationSection: some View {
        VStack(spacing: 40) {
            Text("Affine Transformation (b' = inv)")
                .opacity(viewModel.showTitleOfAff)
                .font(.headline)
            
            VStack(spacing: 15) {
                ForEach(0..<viewModel.values.count, id: \.self) { index in
                    let shiftValues = ["b'", "b' >> 1", "b' >> 2", "b' >> 3", "b' >> 4", "0x63", "Ergebnis"]
                    let operators = ["⊕", "⊕", "⊕", "⊕", "⊕", "="]
                    
                    transformationRow(shiftValue: shiftValues[index],
                                      binaryValues: viewModel.values[index],
                                      opacity: viewModel.showValues[index])
                    
                    if index < 6 {
                        Text(operators[index])
                            .opacity(viewModel.showOperators[index])
                    }
                }
            }
        }
    }
    
    private func transformationRow(shiftValue: String, binaryValues: [Int], opacity: Double) -> some View {
        HStack {
            Text(shiftValue)
                .font(.subheadline)
            Spacer()
            ForEach(Array(binaryValues.enumerated()), id: \.offset) { (_, value) in
                CellView(value: Byte(value), boxSize: 35, backgroundColor: .lightGray, valueFormat: .number)
            }
        }
        .opacity(opacity)
        .frame(width: 425)
    }
}
