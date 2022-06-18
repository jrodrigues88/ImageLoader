//
//  OperationsManager.swift
//  ImageLoader
//
//  Created by Jephin Rodrigues on 16/06/22.
//

import Foundation
import UIKit

class OperationsManager {
    
    static let shared = OperationsManager() //Singleton object for donload operations manager
    var queue = OperationQueue()
    var imageCache = NSCache<AnyObject, AnyObject>() //Images are cached in this once downloaded
    
    private init() {
        queue.maxConcurrentOperationCount = 4
    }
    
    //Synchronous download is handled by adding operation queue with dependency between each operations
    //Async download happens without adding the dependency
    func addDownloadOperation(path1: String?, path2: String?, path3: String?, path4: String?, isSync: Bool) {
        guard let pathStr1 = path1, let url1 = NSURL(string: pathStr1),
        let pathStr2 = path2, let url2 = NSURL(string: pathStr2),
        let pathStr3 = path3, let url3 = NSURL(string: pathStr3),
        let pathStr4 = path4, let url4 = NSURL(string: pathStr4) else {
            return
        }
        
        let operation1 = BlockOperation {
            let data = try? Data(contentsOf: url1 as URL)
            if data != nil {
                let img = UIImage(data: data!)
                self.imageCache.setObject(img!, forKey: pathStr1 as AnyObject)
                NotificationCenter.default.post(name: Notification.Name("ImageDownloaded"), object: nil, userInfo: ["url":pathStr1])
            }
            else {
                NotificationCenter.default.post(name: Notification.Name("ImageDownloaded"), object: nil, userInfo: ["url":pathStr1])
            }
        }
        self.queue.addOperation(operation1)

        let operation2 = BlockOperation {
            let data = try? Data(contentsOf: url2 as URL)
            if data != nil {
                let img = UIImage(data: data!)
                self.imageCache.setObject(img!, forKey: pathStr2 as AnyObject)
                NotificationCenter.default.post(name: Notification.Name("ImageDownloaded"), object: nil, userInfo: ["url":pathStr2])
            }
            else {
                NotificationCenter.default.post(name: Notification.Name("ImageDownloaded"), object: nil, userInfo: ["url":pathStr2])
            }
        }
        if isSync {
            operation2.addDependency(operation1)
        }
        self.queue.addOperation(operation2)
        
        let operation3 = BlockOperation {
            let data = try? Data(contentsOf: url3 as URL)
            if data != nil {
                let img = UIImage(data: data!)
                self.imageCache.setObject(img!, forKey: pathStr3 as AnyObject)
                NotificationCenter.default.post(name: Notification.Name("ImageDownloaded"), object: nil, userInfo: ["url":pathStr3])
            }
            else {
                NotificationCenter.default.post(name: Notification.Name("ImageDownloaded"), object: nil, userInfo: ["url":pathStr3])
            }
        }
        if isSync {
            operation3.addDependency(operation2)
        }
        self.queue.addOperation(operation3)
        
        let operation4 = BlockOperation {
            let data = try? Data(contentsOf: url4 as URL)
            if data != nil {
                let img = UIImage(data: data!)
                self.imageCache.setObject(img!, forKey: pathStr4 as AnyObject)
                NotificationCenter.default.post(name: Notification.Name("ImageDownloaded"), object: nil, userInfo: ["url":pathStr4])
            }
            else {
                NotificationCenter.default.post(name: Notification.Name("ImageDownloaded"), object: nil, userInfo: ["url":pathStr4])
            }
        }
        if isSync {
            operation4.addDependency(operation3)
        }
        self.queue.addOperation(operation4)
    }
    
    //Suspend the download operations in operation queue
    func pauseOperation() {
        self.queue.isSuspended = true
    }
    
    //Resume the download operations in operation queue
    func resumeOperation() {
        self.queue.isSuspended = false
    }
}
