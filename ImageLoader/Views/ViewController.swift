//
//  ViewController.swift
//  ImageLoader
//
//  Created by Jephin Rodrigues on 16/06/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var syncAsyncSegment: UISegmentedControl!
    
    var viewModel = ImageViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        syncAsyncSegment.selectedSegmentIndex = 1
        viewModel.setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Observing the image download completion
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadComplete(notification:)), name: Notification.Name("ImageDownloaded"), object: nil)

    }

    //Downloading sync or async manner based on the segmented selection
    @IBAction func downloadAction(_ sender: Any) {
        switch viewModel.type {
        case .start:
            let isSync = syncAsyncSegment.selectedSegmentIndex == 0
            viewModel.startDownload(sync: isSync)
            
            //Making the button title as 'Pause' once the download starts
            viewModel.type = .pause
            DispatchQueue.main.async {
                self.downloadButton.setTitle("Pause", for: .normal)
                self.syncAsyncSegment.isEnabled = false
            }
        case .pause:
            viewModel.pauseOperation()
            
            //Making the button title as 'Resume' once the download is paused
            viewModel.type = .resume
            DispatchQueue.main.async {
                self.downloadButton.setTitle("Resume", for: .normal)
            }
            
        case .resume:
            viewModel.resumeOperation()
            
            //Making the button title as 'Pause' once the download resumes
            viewModel.type = .pause
            DispatchQueue.main.async {
                self.downloadButton.setTitle("Pause", for: .normal)
            }
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //No actions
        }
    }
    
    //Completed images loaded to UI from image cache
    //Printed the image names to identify the download is happening in selected manner (sync or async)
    @objc func downloadComplete(notification: Notification) {
        if let url = notification.userInfo?["url"] as? String {
            let index = viewModel.getIndexOf(url: url)
            switch index {
            case 1:
                image1.loadUmage(path: url)
                print("IMG1")
            case 2:
                image2.loadUmage(path: url)
                print("IMG2")
            case 3:
                image3.loadUmage(path: url)
                print("IMG3")
            case 4:
                image4.loadUmage(path: url)
                print("IMG4")
            default:
                break
            }
            
            if viewModel.checkAllDone() {
                viewModel.type = .start
                DispatchQueue.main.async {
                    self.downloadButton.setTitle("Download Complete", for: .normal)
                    self.downloadButton.isEnabled = false
                }
            }
        }
    }
}

