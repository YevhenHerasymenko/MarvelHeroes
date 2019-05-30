//
//  CharacterTransform.swift
//  MarvelHeroesCore
//
//  Created by YevhenHerasymenko on 5/30/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import CoreData

extension Character: ModelTransformer {
  typealias CoreDataModel = CharacterEntity

  init(managedObject: CoreDataModel) {
    identifier = Int(managedObject.identifier)
    name = managedObject.name.mandatory()
    description = managedObject.characterDescription.mandatory()
    thumbnail = Thumbnail(managedObject: managedObject.thumbnail.mandatory())
    series = ItemsList(items: [])
    comics = ItemsList(items: [])
    stories = ItemsList(items: [])
    events = ItemsList(items: [])
  }

  @discardableResult func coreDataModel(context: NSManagedObjectContext, order: Int? = nil) -> CoreDataModel {
    let model = CoreDataModel(context: context)
    model.identifier = Int32(identifier)
    model.name = name
    model.characterDescription = description
    model.thumbnail = thumbnail.coreDataModel(context: context)
    return model
  }
}
