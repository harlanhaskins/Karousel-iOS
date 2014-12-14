//
//  GalleryViewController.swift
//  Karousel
//
//  Created by Harlan Haskins on 11/15/14.
//  Copyright (c) 2014 karousel. All rights reserved.
//

import UIKit

private let PhotoCellReuseIdentifier = "PhotoCell"

class GalleryViewController: UICollectionViewController, JTSImageViewControllerInteractionsDelegate {

    var album: Album? {
        didSet {
            self.navigationItem.title = self.album?.name
        }
    }
    
    func showImageFromCell(cell: PhotoCell) {
        if let asset = cell.asset {
            if let image = cell.imageView.image {
                self.displayImage(image, frame: cell.frame)
            }
        }
    }
    
    func displayImage(image: UIImage, frame: CGRect) {
        
        let imageInfo = JTSImageInfo()
        imageInfo.image = image
        imageInfo.referenceRect = frame
        imageInfo.referenceView = self.collectionView
        
        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: .Image, backgroundStyle: .Scaled | .Blurred)
        imageViewer.interactionsDelegate = self
        
        imageViewer.showFromViewController(self, transition: ._FromOriginalPosition)
    }
    
    func imageViewerDidLongPress(imageViewer: JTSImageViewController!, atRect rect: CGRect) {
        let activityView = UIActivityViewController(activityItems: [imageViewer.image], applicationActivities: nil)
        let excludeActivities = [
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo
        ]
        activityView.completionWithItemsHandler = { activityType, completed, returnedItems, error in
            if !completed {
                println("cancelled")
                return
            }
        }
        activityView.popoverPresentationController?.sourceView = imageViewer.view
        imageViewer.presentViewController(activityView, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.album?.assets.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCellReuseIdentifier, forIndexPath: indexPath) as PhotoCell
        
        cell.asset = self.album?.assets[indexPath.row]
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PhotoCell {
            self.showImageFromCell(cell)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}
