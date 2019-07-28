//
//  ImageCaching.swift
//  ImageDisplay
//
//  Created by Keerthana Reddy Ragi on 29/07/19.
//  Copyright © 2019 Keerthana Reddy Ragi. All rights reserved.
//

import UIKit

class ImageCaching: NSObject {
    
    let imageCache = NSCache<NSString, UIImage>()
    static var sharedInstance = ImageCaching()
    private override init(){
        super.init()
        imageCache.countLimit = 1000
    }
}
