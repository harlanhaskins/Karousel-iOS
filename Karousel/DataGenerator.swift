//
//  DataGenerator.swift
//  Karousel
//
//  Created by Harlan Haskins on 11/16/14.
//  Copyright (c) 2014 karousel. All rights reserved.
//

import Foundation

class DataGenerator {
    class func defaultAlbums() -> [Album] {
        if let albumNames = self.lines("albums") {
            return Array(1...10).map { index in
                Album(assets: self.defaultAssetList(), name: albumNames[index % albumNames.count])
            }
        }
        return []
    }
    
    class func lines(fileName: String) -> [String]? {
        if let path = NSBundle.mainBundle().URLForResource(fileName, withExtension: "txt") {
            var error: NSError?
            let urlString = NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding, error: &error)
            if let error = error {
                println("Error: \(error)")
            } else {
                let stripped = urlString?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if let lines = stripped?.componentsSeparatedByString("\n") {
                    return lines
                }
            }
        }
        return nil
    }
    
    class func urls() -> [NSURL]? {
        if let lines = self.lines("urls") {
            return lines.map { NSURL(string: $0)! }
        }
        return nil
    }
    
    class func defaultAssetList() -> [MediaAsset] {
        if let urls = self.urls() {
            let checksums = urls.map { _ in self.randomString(25) }
            return Array(1...100).map { index in
                let random = Int(arc4random_uniform(UInt32(checksums.count)))
                let url = urls[random]
                let checksum = checksums[random]
                return MediaAsset(url: url, type: "original", checksum: checksum)
            }
        }
        return []
    }
    
    class func randomString(length: Int) -> String {
        var string = ""
        let chars = Array(0x30...0x39) + Array(0x41...0x5A) + Array(0x61...0x7A)
        for i in 1...length {
            let c = chars[Int(arc4random_uniform(UInt32(chars.count)))]
            string += String(Character(UnicodeScalar(c)))
        }
        return string
    }
}
