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
                HStack(spacing: 50) {
                    VStack(alignment: .center,
                           spacing: 10) {
                        
                        Text("Aktuelles Byte")
                        
                        CellView(value: 0x00, boxSize: 35, backgroundColor: .lightGray)
                    }
                    
                    VStack(alignment: .center,
                           spacing: 10) {
                        
                        Text("Multiplikates Inverses")
                        
                        CellView(value: 0x63, boxSize: 35, backgroundColor: .lightGray)
                    }
                    

                }
                
                HStack {
                    
                    VStack(spacing: 40) {
                        VStack(spacing: 10) {
                            Text("Affine Transformation")
                                .font(.headline)
                            
                            
                            Text("b ⊕ (b >> 1) ⊕ (b >> 2) ⊕ (b >> 3) ⊕ (b >> 4) ⊕ 0x63")
                                .font(.subheadline)
                            
                        }
                      
                        
                        VStack(spacing: 15) {
                            HStack {
                                Text("b >> 1")
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                ForEach(0..<8, id: \.self) { index in
                                    CellView(value: Byte(index), boxSize: 35, backgroundColor: .lightGray)
                                }
                            }
                            .frame(width: 400)
                            
                            HStack {
                                Text("b >> 2")
                                    .font(.subheadline)
                                Spacer()
                                
                                ForEach(0..<8, id: \.self) { index in
                                    CellView(value: Byte(index), boxSize: 35, backgroundColor: .lightGray)
                                }
                            }
                            .frame(width: 400)
                            
                            HStack {
                                Text("b >> 3")
                                    .font(.subheadline)
                                Spacer()
                                
                                ForEach(0..<8, id: \.self) { index in
                                    CellView(value: Byte(index), boxSize: 35, backgroundColor: .lightGray)
                                }
                            }
                            
                            .frame(width: 400)
                            
                            HStack {
                                Text("b >> 4")
                                    .font(.subheadline)
                                Spacer()
                                
                                ForEach(0..<8, id: \.self) { index in
                                    CellView(value: Byte(index), boxSize: 35, backgroundColor: .lightGray)
                                }
                            }
                            .frame(width: 400)
                            
                            HStack {
                                Text("Result")
                                    .font(.subheadline)
                                Spacer()
                                ForEach(0..<8, id: \.self) { index in
                                    CellView(value: Byte(index), boxSize: 35, backgroundColor: .lightGray)
                                }
                            }
                            .frame(width: 400)
                            
                          
                        }
                    }
       
          
                    
                    Spacer()
                    
                    SBoxView(searchResult: .constant(nil),
                             isInverseMode: viewModel.operationDetails.isInverseMode,
                             opacityOfValues: viewModel.opacityOfSBox
                    )
                    
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
    
    
}
