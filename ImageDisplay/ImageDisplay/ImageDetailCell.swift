//
//  ImageDetailCell.swift
//  ImageDisplay
//
//  Created by Keerthana Reddy Ragi on 28/07/19.
//  Copyright © 2019 Keerthana Reddy Ragi. All rights reserved.
//

import UIKit

class ImageDetailCell: UITableViewCell {
    
    var image1View: UIImageView!
    var image2View: UIImageView!
    var image3View: UIImageView!
    var width = 0
    
    init(width: Int, image1: Photo?, image2: Photo?, image3: Photo?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "")
        selectionStyle = UITableViewCell.SelectionStyle.none
        self.width = width
        
        configureCell()
        if let photoData = image1, let farm = photoData.farm, let server = photoData.server, let identifier = photoData.identifier, let secret = photoData.secret, let imageURL = URL(string: "https://farm\(farm).static.flickr.com/\(server)/\(identifier)_\(secret).jpg") {
            downloadImage(url: imageURL, completion: { image  in
                DispatchQueue.main.async {
                    self.image1View.image = image
                }
            })
            self.image1View.layer.borderColor = UIColor.white.cgColor
            self.image1View.layer.borderWidth = 2
            self.image1View.contentMode = .scaleToFill
        }
        if let photoData = image2, let farm = photoData.farm, let server = photoData.server, let identifier = photoData.identifier, let secret = photoData.secret, let imageURL = URL(string: "https://farm\(farm).static.flickr.com/\(server)/\(identifier)_\(secret).jpg") {
            downloadImage(url: imageURL, completion: { image in
                DispatchQueue.main.async {
                    self.image2View.image = image
                }
            })
            self.image2View.layer.borderColor = UIColor.white.cgColor
            self.image2View.layer.borderWidth = 2
            self.image2View.contentMode = .scaleToFill
        }
        if let photoData = image3, let farm = photoData.farm, let server = photoData.server, let identifier = photoData.identifier, let secret = photoData.secret, let imageURL = URL(string: "https://farm\(farm).static.flickr.com/\(server)/\(identifier)_\(secret).jpg") {
            downloadImage(url: imageURL, completion: { image in
                DispatchQueue.main.async {
                    self.image3View.image = image
                }
            })
            self.image3View.layer.borderColor = UIColor.white.cgColor
            self.image3View.layer.borderWidth = 2
            self.image3View.contentMode = .scaleToFill
        }
        addSubview(image1View)
        addSubview(image2View)
        addSubview(image3View)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        image1View = UIImageView(frame: CGRect(x: 0, y: 0, width: width/3, height: width/3))
        image2View = UIImageView(frame: CGRect(x: width/3, y: 0, width: width/3, height: width/3))
        image3View = UIImageView(frame: CGRect(x: 2*width/3, y: 0, width: width/3, height: width/3))
    }
    
    func downloadImage(url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
        if let cachedImage = ImageCaching.sharedInstance.imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
        } else {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    ImageCaching.sharedInstance.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image)
                }
                }.resume()
        }
    }
    
}
