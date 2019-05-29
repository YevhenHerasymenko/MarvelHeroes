//
//  CoreDataWorker.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/29/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

import CoreData

enum CoreDataWorker {

  static func clearAllData(service: NSPersistentContainer) {
//    let entities = [
//      FileEntity.description()
//    ]
//    entities.forEach { entityDescription in
//      let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityDescription)
//      do {
//        let result = try service.viewContext.fetch(request)
//        for object in result {
//          guard let objectData = object as? NSManagedObject else {continue}
//          service.viewContext.delete(objectData)
//        }
//        try service.viewContext.save()
//      } catch {
//        fatalError(error.localizedDescription)
//      }
//    }
  }

  // MARK: Meetings

  static func store(service: NSPersistentContainer) {

  }

}
