//
//  ImageDataSource.swift
//  ImageDisplay
//
//  Created by Keerthana Reddy Ragi on 28/07/19.
//  Copyright © 2019 Keerthana Reddy Ragi. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}

enum ImagesStoreError: Error {
    case parameterError
    case networkError
    case serverError
    case parseError
}

protocol Store {
    func fetchImages(searchQuery: String, result: @escaping ((Result<ImageDataModel>) -> Void))
    func fetchMore(result: @escaping ((Result<ImageDataModel>) -> Void))
}

class ImageDataSource: Store {
    
    var lastPageFetched = 1
    var lastSearchQuery = ""
    let session = URLSession.shared
    
    public func fetchImages(searchQuery: String = "", result: @escaping ((Result<ImageDataModel>) -> Void)) {
        let encodedQuery = searchQuery.replacingOccurrences(of: " ", with: "%2C")
        
        if lastSearchQuery != encodedQuery {
            lastSearchQuery = encodedQuery
            lastPageFetched = 1
        }
        
        let urlSearch = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text=\(lastSearchQuery)&page=\(lastPageFetched)"
        
        guard let url = URL(string: urlSearch) else {
            result(.error(ImagesStoreError.parameterError))
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.error(error))
            }
            
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard let imagesModel = try? JSONDecoder().decode(ImageDataModel.self, from: data) else {
                    result(.error(ImagesStoreError.parseError))
                    return
                }
                DispatchQueue.main.async {
                    result(.success(imagesModel))
                }
            } else {
                result(.error(ImagesStoreError.serverError))
            }
            }.resume()
    }
    
    public func fetchMore(result: @escaping ((Result<ImageDataModel>) -> Void)) {
        lastPageFetched += 1
        self.fetchImages(searchQuery: lastSearchQuery, result: result)
    }
}
