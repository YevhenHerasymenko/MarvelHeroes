//
//  ThumbnailTransform.swift
//  MarvelHeroesCore
//
//  Created by YevhenHerasymenko on 5/30/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import CoreData

extension Thumbnail: ModelTransformer {
  typealias CoreDataModel = ThumbnailEntity

  init(managedObject: CoreDataModel) {
    path = managedObject.path.mandatory()
    pathExtension = managedObject.pathExtension.mandatory()
  }

  @discardableResult func coreDataModel(context: NSManagedObjectContext, order: Int? = nil) -> CoreDataModel {
    let model = CoreDataModel(context: context)
    model.path = path
    model.pathExtension = pathExtension
    return model
  }

}
