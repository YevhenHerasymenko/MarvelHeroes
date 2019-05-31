//
//  SearchCharactersTest.swift
//  MarvelHeroesCoreTests
//
//  Created by Yevhen Herasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import XCTest
@testable import MarvelHeroesCore

class SearchCharactersTests: XCTestCase {

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

  func testHandleDisplayAction() {
    store = StoreHelper.emptyStore
    store.dispatch(SearchCharactersFlow.Actions.setAction(.loading))
    XCTAssertNotNil(store.state.searchCharactersState.action)
    store.dispatch(SearchCharactersFlow.didHandleAction())
    XCTAssertNil(store.state.searchCharactersState.action)
  }

}
