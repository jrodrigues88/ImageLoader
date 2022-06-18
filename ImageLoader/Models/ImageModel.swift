//
//  ImageModel.swift
//  ImageLoader
//
//  Created by Jephin Rodrigues on 16/06/22.
//

import Foundation

//Model to hold image details
struct ImageModel {
    
    var imageUrl: String?
    var loadingProgress: Double = 0
    var index: Int = 0
    
    mutating func updateProgress() {
        self.loadingProgress = 100
    }
}
