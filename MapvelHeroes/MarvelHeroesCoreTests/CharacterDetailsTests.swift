//
//  CharacterDetailsTests.swift
//  MarvelHeroesCoreTests
//
//  Created by Yevhen Herasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import XCTest
@testable import MarvelHeroesCore

class CharacterDetailsTests: XCTestCase {

  var store: Store<AppState>!

  override func setUp() {
    super.setUp()
    self.continueAfterFailure = false
  }

  override func tearDown() {
    store.dispatch(AppState.clearData())
    store = nil
    super.tearDown()
  }

}
