//
//  StoreHelper.swift
//  MarvelHeroesCoreTests
//
//  Created by Yevhen Herasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

@testable import MarvelHeroesCore

class StoreHelper {

  static var emptyStore: Store<AppState> {
    return storeWith(mockRoutings: [])
  }

  static func storeWith(mockRoutings: [MockRouting]) -> Store<AppState> {
    let requiredRoutings = MockRoutingHelper.requiredByMiddleware.filter { routing in
      !mockRoutings.contains { routing.isEqualTo(otherRouting: $0.routing) }
    }
    return createStore(
      MockSessionManager(scenarios: mockRoutings + requiredRoutings),
      MockPersistantManager()
    )
  }

}
