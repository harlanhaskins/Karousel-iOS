//
//  MediaAsset.swift
//  Karousel
//
//  Created by Harlan Haskins on 11/15/14.
//  Copyright (c) 2014 karousel. All rights reserved.
//

import UIKit
import Alamofire


protocol MediaAssetDelegate {
   func asset(asset: MediaAsset, didLoadImage image: UIImage, fromCache: Bool)
   func asset(asset: MediaAsset, didFailWithError error: NSError)
}

enum MediaAssetState {
   case Unloaded
   case Loading
   case Loaded
   case Failed
}

class MediaAsset: Cacheable {
   
   /// The remote URL that the image loads.
   var url: NSURL
   
   /// The checksum of the image, used for caching.
   let checksum: String
   
   /// The type of file.
   let type: String
   
   /// A reference to the image itself, if loaded.
   var image: UIImage?
   
   /// A delegate to call back to once
   var delegate: MediaAssetDelegate?
   
   var key: String {
      return self.checksum
   }
   
   init(url: NSURL, type: String, checksum: String) {
      self.url = url
      self.checksum = checksum
      self.type = type
   }
   
   func loadImage() {
      if let image = self.image {
         self.delegate?.asset(self, didLoadImage: image, fromCache: false)
         return
      }
      Snapcache.sharedCache.loadImageForObject(self)
   }
   
   func snapcache(manager: Snapcache, didLoadImage image: UIImage) {
      self.image = image
      self.delegate?.asset(self, didLoadImage: image, fromCache: true)
   }
   
   func snapcache(manager: Snapcache, didFailWithError error: NSError) {
      self.delegate?.asset(self, didFailWithError: error)
   }
   
}
