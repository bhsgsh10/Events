//
//  ImageDownloader.swift
//  Events
//
//  Created by Bhaskar Ghosh on 27/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import Foundation
import UIKit

//The purpose of the ImageDownloader is to download the image from the given URL
class ImageDownloader: NSObject {

    class func downloadImageWithURL(url:String) -> UIImage? {
        
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        return UIImage(data: data!)
    }
}
