//
//  PersistentManager.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/29/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

import CoreData

/// General persistent manager protocol
public protocol PersistentManager {
}

extension NSPersistentContainer: PersistentManager {}

/// create and setup persistent stack
public func createAndSetupCoreDataPersistenceStack() -> PersistentManager {
  guard
    let bundle = Bundle(identifier: "com.yevhenherasymenko.MarvelHeroesCore"),
    let url = bundle.url(forResource: "MarvelCoreDataModel", withExtension: "momd"),
    let model = NSManagedObjectModel(contentsOf: url) else {
      fatalError("can't load model in bundle")
  }
  let container = NSPersistentContainer(name: "MarvelCoreDataModel", managedObjectModel: model)
  container.loadPersistentStores { (_, error) in
    if let error = error {
      fatalError(error.localizedDescription)
    }
  }
  container.viewContext.mergePolicy = NSOverwriteMergePolicy
  return container
}
