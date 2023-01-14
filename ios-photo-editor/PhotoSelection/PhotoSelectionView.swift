//
//  PhotoSelectionView.swift
//  ios-photo-editor
//
//  Created by Vadim Popov on 13.01.2023.
//

import SwiftUI
import PhotosUI


struct PhotoSelectionView: View {
    
    @Binding var imageData: Data?
    @State private var imageSelection: PhotosPickerItem?
    
    var body: some View {
        PhotosPicker(selection: $imageSelection,
                     matching: .images,
                     photoLibrary: .shared()) {
            Image(systemName: "pencil.circle.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 30))
                .foregroundColor(.accentColor)
        }
        .buttonStyle(.borderless)
        .onChange(of: imageSelection) { newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    imageData = data
                }
            }
        }
    }
    
}
