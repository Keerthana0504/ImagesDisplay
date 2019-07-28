//
//  ImagesDisplayMocks.swift
//  ImageDisplay
//
//  Created by Keerthana Reddy Ragi on 29/07/19.
//  Copyright © 2019 Keerthana Reddy Ragi. All rights reserved.
//

import Foundation
@testable import ImageDisplay

enum ImagesDisplayMocks {
    class MockStore: Store {
        func fetchImages(searchQuery: String, result: @escaping ((Result<ImageDataModel>) -> Void)) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                result(.success(self.mockedResponseModel))
            }
            
        }
        
        func fetchMore(result: @escaping ((Result<ImageDataModel>) -> Void)) {
            
        }
        
        var mockedResponseModel: ImageDataModel {
            return ImageDataModel(images: imagesDisplay)
        }
        
        var imagesDisplay: Images {
            let mockPhoto1 = Photo(identifier: "48396240272", farm: 1, server: "0", secret: "18f96086bd")
            let mockPhoto2 = Photo(identifier: "483962402", farm: 1, server: "0", secret: "18f96086bd")
            let photos = [mockPhoto1, mockPhoto2]
            let images: Images = Images(photo: photos)
            return images
        }
    }
}

