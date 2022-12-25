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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
