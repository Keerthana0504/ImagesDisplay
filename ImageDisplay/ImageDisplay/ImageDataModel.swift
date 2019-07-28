//
//  ImageDataModel.swift
//  ImageDisplay
//
//  Created by Keerthana Reddy Ragi on 28/07/19.
//  Copyright © 2019 Keerthana Reddy Ragi. All rights reserved.
//

import Foundation

struct ImageDataModel: Decodable {
    let images: Images
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        images = try container.decode(Images.self, forKey: .images)
    }
    
    init(images: Images) {
        self.images = images
    }
    
    enum CodingKeys: String, CodingKey {
        case images = "photos"
    }
}

struct Images: Decodable {
    let photo: [Photo]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        photo = try container.decode([Photo].self, forKey: .photo)
    }
    
    init(photo: [Photo]) {
        self.photo = photo
    }
    
    enum CodingKeys: String, CodingKey {
        case photo
    }
}

struct Photo: Decodable {
    let identifier: String?
    let farm: Int?
    let server: String?
    let secret: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try? container.decode(String.self, forKey: .identifier)
        farm = try? container.decode(Int.self, forKey: .farm)
        server = try? container.decode(String.self, forKey: .server)
        secret = try? container.decode(String.self, forKey: .secret)
    }
    
    init(identifier: String?, farm: Int?, server: String?, secret: String?) {
        self.identifier = identifier
        self.farm = farm
        self.server = server
        self.secret = secret
    }
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case farm
        case server
        case secret
    }
}





