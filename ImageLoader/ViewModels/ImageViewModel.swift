//
//  ImageViewModel.swift
//  ImageLoader
//
//  Created by Jephin Rodrigues on 16/06/22.
//

import Foundation

//Enum to handle the sutton states
enum ButtonType {
  case start, pause, resume
}

class ImageViewModel {
    
    var imageModels = [ImageModel]()
    var type = ButtonType.start
    
    //Initial view model setup by adding all 4 urls
    func setupViewModel() {
        let image1 = ImageModel(imageUrl: "https://cdn.wallpapersafari.com/36/6/WCkZue.png", loadingProgress: 0, index: 1)
        let image2 = ImageModel(imageUrl: "https://www.iliketowastemytime.com/sites/default/files/hamburg-germany-nicolas-kamp-hd-wallpaper_0.jpg", loadingProgress: 0, index: 2)
        let image3 = ImageModel(imageUrl: "https://images.hdqwalls.com/download/drift-transformers-5-the-last-knight-qu-5120x2880.jpg", loadingProgress: 0, index: 3)
        let image4 = ImageModel(imageUrl: "https://survarium.com/sites/default/files/calendars/survarium-wallpaper-calendar-february-2016-en-2560x1440.png", loadingProgress: 0, index: 4)
        
        imageModels.append(image1)
        imageModels.append(image2)
        imageModels.append(image3)
        imageModels.append(image4)
    }
    
    //Start Downloading the images in sync/async manner
    func startDownload(sync: Bool) {
        let manager = OperationsManager.shared
        manager.addDownloadOperation(path1: getImageUrlAt(index: 1), path2: getImageUrlAt(index: 2), path3: getImageUrlAt(index: 3), path4: getImageUrlAt(index: 4), isSync: sync)
    }
    
    //Get image url based on the index
    func getImageUrlAt(index: Int) -> String? {
        if imageModels.count > 0 && imageModels.count >= index {
            let model = imageModels[index-1]
            return model.imageUrl
        }
        return nil
    }
    
    //Get the index of image url
    //This method is getting called when that image is downloaded.
    //So making the progress to 100.
    func getIndexOf(url: String) -> Int {
        for (index, element) in imageModels.enumerated() {
            if element.imageUrl == url {
                imageModels[index].updateProgress()
                return element.index
            }
        }
        return 0
    }
    
    //Checking if all images are downloaded
    func checkAllDone() -> Bool {
        var allDone = true
        for eachItem in imageModels {
            if eachItem.loadingProgress == 0 {
                allDone = false
                break
            }
        }
        return allDone
    }
    
    //Pause download operations
    func pauseOperation() {
        let manager = OperationsManager.shared
        manager.pauseOperation()
    }
    
    //Resume download operations
    func resumeOperation() {
        let manager = OperationsManager.shared
        manager.resumeOperation()
    }
}
