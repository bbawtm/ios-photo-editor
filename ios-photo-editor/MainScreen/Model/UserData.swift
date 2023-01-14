//
//  UserData.swift
//  ios-photo-editor
//
//  Created by Vadim Popov on 08.01.2023.
//

import SwiftUI


class UserData: ObservableObject {
    
    let image: UIImage
    let imageScreenScale: Double
    
    init(imageData: Data) {
        guard let img = UIImage(data: imageData)
        else { fatalError("UserData incorrect image data") }
        
        self.image = img
        let widthScale = 1.0 * UIScreen.main.bounds.size.width / self.image.size.width
        let heightScale = 1.0 * (UIScreen.main.bounds.size.height - 280) / self.image.size.height
        self.imageScreenScale = min(heightScale, widthScale)
    }
    
}
