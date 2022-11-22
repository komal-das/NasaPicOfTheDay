//
//  ApodEntity+CoreDataProperties.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//
//

import Foundation
import CoreData


extension ApodEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ApodEntity> {
        return NSFetchRequest<ApodEntity>(entityName: "ApodEntity")
    }

    @NSManaged public var date: String
    @NSManaged public var explanation: String
    @NSManaged public var imageOrVideoUrl: String
    @NSManaged public var isVideo: Bool
    @NSManaged public var thumbnail: String?
    @NSManaged public var title: String

}

extension ApodEntity : Identifiable {

}
