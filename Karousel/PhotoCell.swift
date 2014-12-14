//
//  PhotoCell.swift
//  Karousel
//
//  Created by Harlan Haskins on 11/15/14.
//  Copyright (c) 2014 karousel. All rights reserved.
//

import UIKit

private let FailedImageName = "Failed"

// Initialize a failure image one time.
private let FailedImage = UIImage(named: FailedImageName)!

class PhotoCell: UICollectionViewCell, MediaAssetDelegate {
    @IBOutlet var imageView: UIImageView!
    
    var asset: MediaAsset? {
        didSet {
            if let asset = self.asset {
                asset.delegate = self
                asset.loadImage()
            } else {
                self.removeImage()
            }
        }
    }
    
    func asset(asset: MediaAsset, didLoadImage image: UIImage, fromCache: Bool) {
        Async.main {
            if fromCache {
                self.imageView.fadeImage(image)
            } else {
                self.imageView.image = image
            }
        }
    }
    
    func asset(asset: MediaAsset, didFailWithError error: NSError) {
        Async.main {
            self.imageView.fadeImage(FailedImage)
            println("Error: \(error.userInfo)")
        }
    }

    func removeImage() {
        self.imageView.image = nil
    }
    
    override func prepareForReuse() {
        self.asset?.delegate = nil
        self.asset = nil
    }
}

extension UIImageView {
    
    func fadeImage(image: UIImage) {
        UIView.transitionWithView(self,
            duration: 0.25,
            options: .TransitionCrossDissolve,
            animations: {
                self.image = image
            }, completion: nil)
    }
}
