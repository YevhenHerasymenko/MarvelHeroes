//
//  PersistenceMiddleware.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/29/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

enum PersistanceActions: Action {
  case store
}

import CoreData

enum PersistenceMiddleware {

  static func persistance(service: PersistentManager) -> MiddlewareType {
    return {
      if let coreDataService = service as? NSPersistentContainer {
        return coreDataPersistance(action: $0, context: $1, service: coreDataService)
      } else {
        return noPersistance(action: $0, context: $1, service: service)
      }
    }
  }

}

extension PersistenceMiddleware {

  private static func coreDataPersistance(action: Action,
                                          context: MiddlewareContext<AppState>,
                                          service: NSPersistentContainer) -> Action? {
    if let appStateAction = action as? AppState.Actions, case .clearData = appStateAction {
      CoreDataWorker.clearAllData(service: service)
      return action
    }
    guard let persistentAction = action as? PersistanceActions else {
      return action
    }
    switch persistentAction {
    case .store:
      CoreDataWorker.store(service: service)
    }
    return nil
  }

  private static func noPersistance(action: Action,
                                    context: MiddlewareContext<AppState>,
                                    service: PersistentManager) -> Action? {
    return action
  }
}
