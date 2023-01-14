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
        Spacer()
        Text("Photo Editor")
            .font(.largeTitle)
        Spacer()
        Spacer()
        PhotosPicker(
            selection: $imageSelection,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Text("Get started")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.top, 10)
                .padding(.bottom, 10)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .background {
                    Rectangle()
                }
                .cornerRadius(100)
        }
        .buttonStyle(.borderless)
        .onChange(of: imageSelection) { newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    imageData = data
                }
            }
        }
        .padding(.bottom, 100)
    }
    
}
