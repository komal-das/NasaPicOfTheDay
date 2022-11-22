//
//  ApodEntity+CoreDataClass.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//
//

import Foundation
import CoreData

@objc(ApodEntity)
public class ApodEntity: NSManagedObject {

}

extension ApodEntity {
    func update(with apod: Apod) {
        self.title = apod.title
        self.explanation = apod.explanation
        self.isVideo = apod.mediaType == .video ? true : false
        self.thumbnail = apod.thumbnailUrl
        self.date = apod.date
        self.imageOrVideoUrl = apod.url
    }
}
