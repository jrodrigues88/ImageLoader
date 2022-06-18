//
//  Utilities.swift
//  ImageLoader
//
//  Created by Jephin Rodrigues on 16/06/22.
//

import Foundation
import UIKit

//Extension for imageview to load image form cache
extension UIImageView {
    
    //This method is getting called after the image is downloaded.
    //So the image will be cached in image cache. Just use the image to load in UI
    func loadUmage(path: String?) {
        guard let pathStr = path else {
            return
        }
        if let cacheImage = OperationsManager.shared.imageCache.object(forKey: pathStr as AnyObject) as? UIImage {
            DispatchQueue.main.async {
                self.image = cacheImage
            }
        }
        else {
            DispatchQueue.main.async {
                //If no image in cache, we are loading a placeholder image which indicates the url doesnot contain a valid image to download.
                self.image = UIImage(named: "noimage")
            }
        }
    }
}
