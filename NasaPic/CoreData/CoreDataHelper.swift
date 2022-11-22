//
//  CoreDataHelper.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//

import Foundation
import CoreData

final class CoreDataHelper {
    static let shared = CoreDataHelper()
    private init() {}
    
    /// Get Apod data from CoreData
    /// - Parameters:
    ///   - dateString: dateString
    ///   - completion: Completion Handler
    func getApod(forSelectedDate dateString: String, completion : @escaping (Apod?) -> Void) {
        CoreDataStack.shared.performViewTask { context in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ApodEntity")
            fetchRequest.predicate = NSPredicate(format: "date == %@", dateString)
            
            do {
                guard let results = try context.fetch(fetchRequest) as? [ApodEntity] else {
                    completion(nil)
                    return
                }
                let apodModel = results.compactMap { Apod(withApodEntity: $0) }.first
                completion(apodModel)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Get Last shown Apod data from CoreData
    /// - Parameters:
    ///   - completion: Completion Handler
    func getLastShownApod(completion : @escaping (Apod?) -> Void) {
        CoreDataStack.shared.performViewTask { context in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ApodEntity")
            fetchRequest.fetchLimit = 1
            do {
                guard let results = try context.fetch(fetchRequest) as? [ApodEntity] else {
                    completion(nil)
                    return
                }
                let apodModel = results.compactMap { Apod(withApodEntity: $0) }.first
                completion(apodModel)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Save APOD list to CoreData
    /// - Parameters:
    ///   - apodList: item list
    ///   - completion: Completion Handler
    func syncApod(_ apodList: [Apod], completion: @escaping (Bool) -> Void) {
        CoreDataStack.shared.performViewTask { context in
            for apod in apodList {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ApodEntity")
                fetchRequest.predicate = NSPredicate(format: "date == %@", apod.date)
                do {
                    //if exists update else insert new record
                    if let results = try context.fetch(fetchRequest) as? [ApodEntity], !results.isEmpty {
                        //debugPrint("existing.....\(results.count)")
                        results.first?.update(with: apod)
                    } else {
                        guard let apodEntity = NSEntityDescription.insertNewObject(forEntityName: "ApodEntity", into: context) as? ApodEntity else {
                            debugPrint("Error: Failed to create ApodEntity")
                            return
                        }
                        apodEntity.update(with: apod)
                    }
                } catch {
                    debugPrint("Error: \(error.localizedDescription)")
                }
            }
            CoreDataStack.shared.save(context: context) { isSuccess in
                completion(isSuccess)
            }
        }
    }
}
