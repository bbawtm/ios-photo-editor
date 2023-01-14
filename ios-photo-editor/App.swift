//
//  App.swift
//  ios-photo-editor
//
//  Created by Vadim Popov on 25.12.2022.
//

import SwiftUI

@main
struct ios_photo_editorApp: App {
    let persistenceController = PersistenceController.shared
    @State var imageData: Data?

    var body: some Scene {
        WindowGroup {
            if let imageData {
                EditorView()
                    .preferredColorScheme(.dark)
                    .environmentObject(UserData(imageData: imageData))
            } else {
                PhotoSelectionView(imageData: $imageData)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
