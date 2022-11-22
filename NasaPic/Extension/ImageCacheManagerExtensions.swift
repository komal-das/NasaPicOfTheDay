//
//  ImageCacheManagerExtensions.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//

import Foundation
import UIKit

extension URLCache {
    static let imageCache = URLCache()

    enum LoadImageError: Error {
        case failedResponse
        case unexpectedError
    }

    @discardableResult
    final func loadImage(url: URL,
                         session: URLSession = URLSession.shared,
                         completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionTask?
    {
        let request = URLRequest(url: url)
        if let data = cachedResponse(for: URLRequest(url: url))?.data,
           let image = UIImage(data: data)
        {
            completion(.success(image))
            return nil
        } else {
            let dataTask = session.dataTask(with: request, completionHandler: { [weak self] data, response, _ in
                if let self = self,
                   let data = data,
                   let response = response,
                   ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data)
                {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    self.storeCachedResponse(cachedData, for: request)
                    completion(.success(image))
                } else {
                    completion(.failure(LoadImageError.failedResponse))
                }
            })
            dataTask.resume()
            return dataTask
        }
    }
}
