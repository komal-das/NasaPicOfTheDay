//
//  ImageView+Extension.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//

import UIKit

extension UIImageView {
    enum LoadImageCache {
        typealias LoadResult = (Result<UIImage, Error>) -> Void
    }

    @discardableResult
    func load(url: URL,
              placeholder: UIImage? = nil,
              cache: URLCache = URLCache.imageCache,
              completion: LoadImageCache.LoadResult? = nil) -> URLSessionTask?
    {
        guard let data = cache.cachedResponse(for: URLRequest(url: url))?.data else {
            if let placeholder = placeholder {
                image = placeholder
            }
            return cache.loadImage(url: url) { result in
                switch result {
                case let .success(image):
                    DispatchQueue.main.async { [weak self] in
                        if let self = self {
                            self.image = image
                            completion?(.success(image))
                        } else {
                            completion?(.failure(URLCache.LoadImageError.unexpectedError))
                        }
                    }
                case let .failure(error):
                    completion?(.failure(error))
                }
            }
        }
        image = UIImage(data: data)
        if let image = image {
            completion?(.success(image))
        }
        return nil
    }
}
