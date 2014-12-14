//
//  AlbumViewController.swift
//  Karousel
//
//  Created by Harlan Haskins on 11/15/14.
//  Copyright (c) 2014 karousel. All rights reserved.
//

import UIKit

class AlbumsViewController: UITableViewController {

    var albums = [Album]()
    
    override func awakeFromNib() {
        self.albums = DataGenerator.defaultAlbums()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Album" {
            if let cell = sender as? UITableViewCell {
                if let indexPath = self.tableView.indexPathForCell(cell) {
                    let album = self.albums[indexPath.row] as Album
                    let viewController = (segue.destinationViewController as UINavigationController).topViewController as GalleryViewController
                    viewController.album = album
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as UITableViewCell
        
        let album = self.albums[indexPath.row] as Album
        
        cell.textLabel?.text = album.name
        
        return cell
    }
    
}
