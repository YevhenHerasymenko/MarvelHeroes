//
//  ModelTransformer.swift
//  MarvelHeroesCore
//
//  Created by YevhenHerasymenko on 5/30/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import CoreData

extension Optional {
  func mandatory() -> Wrapped {
    guard let wrapped = self else {
      fatalError("can't load property")
    }
    return wrapped
  }
}

protocol ModelTransformer {
  associatedtype CoreDataModel: NSManagedObject
  func coreDataModel(context: NSManagedObjectContext, order: Int?) -> CoreDataModel
  init(managedObject: CoreDataModel)
}
