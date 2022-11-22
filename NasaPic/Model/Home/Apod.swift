//
//  Apod.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//

import Foundation

struct Apod: Codable {
    let title: String
    let date, explanation: String
    let mediaType: MediaType
    let url: String
    let thumbnailUrl: String?

    enum CodingKeys: String, CodingKey {
        case date, explanation
        case mediaType = "media_type"
        case title, url
        case thumbnailUrl = "thumbnail_url"
    }
}

enum MediaType: String, Codable {
    case image = "image"
    case video = "video"
}

extension Apod {
    init(withApodEntity item: ApodEntity) {
        self.title = item.title
        self.date = item.date
        self.explanation = item.explanation
        self.url = item.imageOrVideoUrl
        self.thumbnailUrl = item.thumbnail
        self.mediaType = item.isVideo ? .video : .image
    }
}
