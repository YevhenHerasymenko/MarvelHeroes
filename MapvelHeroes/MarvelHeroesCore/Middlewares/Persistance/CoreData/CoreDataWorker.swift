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
    let entities = [
      CharacterEntity.description(),
      ThumbnailEntity.description()
    ]
    entities.forEach { entityDescription in
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityDescription)
      do {
        let result = try service.viewContext.fetch(request)
        for object in result {
          guard let objectData = object as? NSManagedObject else {continue}
          service.viewContext.delete(objectData)
        }
        try service.viewContext.save()
      } catch {
        fatalError(error.localizedDescription)
      }
    }
  }

  // MARK: Characters

  static func loadCharacters(service: NSPersistentContainer) -> [Character]? {
    let context = service.viewContext
    var characters: [Character]?
    context.performAndWait {
      let request: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
      let persistentCharacters = try? context.fetch(request)
      characters = persistentCharacters?.map { Character(managedObject: $0) }
    }
    return characters
  }

  static func store(character: Character, service: NSPersistentContainer) {
    let context = service.viewContext
    context.performAndWait {
      character.coreDataModel(context: context)
    }
    try? context.save()
  }

  static func delete(character: Character, service: NSPersistentContainer) {
    let context = service.viewContext
    context.performAndWait {
      let request: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
      request.predicate = NSPredicate(format: "identifier == %d", character.identifier)
      let oldCharacters = try? context.fetch(request)
      oldCharacters?.forEach { context.delete($0) }
    }
    try? context.save()
  }

}
