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
    
    // MARK: - Computed Properties for View
    var boxSize: CGFloat {
        #if os(iOS)
        DeviceDetector.isPad13Size() ? 35 : 30
        #else
        35
        #endif
    }
    
    var spacing: CGFloat { 5 }
    
    var frameWidthForBinary: CGFloat {
        (boxSize + spacing) * 7 + boxSize
    }
    
    var frameWidthTotal: CGFloat { frameWidthForBinary + 85 }
    
    // MARK: -
    var body: some View {
        AnimationContainerView(viewModel: viewModel) {
            VStack(spacing: 25) {
                byteDisplaySection
                sBoxSection
            }
            #if os(iOS)
            .toolbar { closeButton { dismiss() } }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
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
            
            if viewModel.operationDetails.isInverseMode {
                byteCell(title: "Position der S-Box",
                         value: viewModel.resultSBox,
                         opacity: viewModel.showResultSBox)
                
                byteCell(title: "Wert der S-Box",
                         value: viewModel.indexOfSBox,
                         opacity: viewModel.showIndexOfSBox)
            }
             
            byteCell(title: "Ergebnis",
                     value: viewModel.resultSBox,
                     opacity: viewModel.showResultSBox)
            
            
        }
    }
    
    private func byteCell(title: LocalizedStringKey, value: Byte, opacity: Double) -> some View {
        VStack(alignment: .center, spacing: 10) {
            Text(title)
            CellView(value: value, boxSize: 35, backgroundColor: .lightGray)
        }
        .opacity(opacity)
    }
    
    // MARK: - Affine Transformation Section
    private var sBoxSection: some View {
        HStack {
            affineTransformationSection
            
            Spacer()
            
            SBoxView(isInverseMode: viewModel.operationDetails.isInverseMode,
                     opacityOfValues: viewModel.opacityOfSBox)
        }
    }
    
    private var affineTransformationSection: some View {
        VStack(spacing: 40) {
            Text("Affine Transformation (b' = inv)")
                .opacity(viewModel.showTitleOfAff)
                .font(.headline)
            
            VStack(spacing: spacing) {
                ForEach(0..<viewModel.values.count, id: \.self) { index in
                    let shiftValues = ["b'", "b' >> 1", "b' >> 2", "b' >> 3", "b' >> 4", "0x63", "Ergebnis"]
                    let operators = ["⊕", "⊕", "⊕", "⊕", "⊕", "="]
                    
                    transformationRow(index: index, shiftValues: shiftValues, operators: operators)
                }
            }
        }
        .padding(.bottom, 40)
        
    }
    
    private func transformationRow(index: Int,
                                   shiftValues: [String],
                                   operators: [String]) -> some View {
        VStack(spacing: spacing) {
            // Text and box perfectly aligned center
            HStack {
                Text(shiftValues[index])
                    .font(.headline)
                
                Spacer()
                
                HStack(spacing: spacing) {
                    ForEach(Array(viewModel.values[index].enumerated()), id: \.offset) { (_, value) in
                        CellView(value: Byte(value),
                                 boxSize: boxSize,
                                 backgroundColor: .lightGray,
                                 valueFormat: .number)
                    }
                }
            }
            
            if index < 6 {
                HStack {
                    Spacer()
                    
                    Text(operators[index])
                        .font(.headline)
                        .opacity(viewModel.showOperators[index])
                        .frame(width: frameWidthForBinary, alignment: .center)
                    
                }
            }
            
        }
        .opacity(viewModel.showValues[index])
        .frame(width: frameWidthTotal)
    }
}
