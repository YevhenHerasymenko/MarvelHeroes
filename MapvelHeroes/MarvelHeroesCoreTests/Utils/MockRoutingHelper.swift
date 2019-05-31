//
//  MockRoutingHelper.swift
//  MarvelHeroesCoreTests
//
//  Created by Yevhen Herasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation
@testable import MarvelHeroesCore

class MockRoutingHelper {

  static var requiredByMiddleware: [MockRouting] {
    return []
  }

  enum Success {

    static var characters: MockRouting {
      return MockRouting(
        routing: CharacterEndpoints.characters(offset: 0, name: nil),
        result: .success(fileName: .characters)
      )
    }

    static var item: MockRouting {
      return MockRouting(
        routing: CharacterEndpoints.itemDetails(urlValue: ""),
        result: .success(fileName: .item)
      )
    }
  }

  enum Fail {

    static var characters: MockRouting {
      return MockRouting(
        routing: CharacterEndpoints.characters(offset: 0, name: nil),
        result: .customError(.badResponse)
      )
    }

    static var item: MockRouting {
      return MockRouting(
        routing: CharacterEndpoints.itemDetails(urlValue: ""),
        result: .customError(.badResponse)
      )
    }

  }

}
