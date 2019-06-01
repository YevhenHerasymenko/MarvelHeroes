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

  func testSuccessLoadCharacters() {
    store = StoreHelper.storeWith(mockRoutings: [
      MockRoutingHelper.Success.characters
      ]
    )

    let promise = expectation(description: #function)
    promise.assertForOverFulfill = false
    let stubSubscriber = StubSubscriber<AppState>(promise: promise) { state in
      return !state.searchCharactersState.characters.isEmpty
    }
    store.subscribe(stubSubscriber)
    store.dispatch(SearchCharactersFlow.reloadContent())
    waitForExpectations(timeout: 5, handler: nil)
    store.unsubscribe(stubSubscriber)

    XCTAssertEqual(store.state.searchCharactersState.characters.count, 20)
  }

  func testFailLoadCharacters() {
    store = StoreHelper.storeWith(mockRoutings: [
      MockRoutingHelper.Fail.characters
      ]
    )

    let promise = expectation(description: #function)
    promise.assertForOverFulfill = false
    let stubSubscriber = StubSubscriber<AppState>(promise: promise) { state in
      if case .some(.error) = state.searchCharactersState.action {
        return true
      } else {
        return false
      }
    }
    store.subscribe(stubSubscriber)
    store.dispatch(SearchCharactersFlow.reloadContent())
    waitForExpectations(timeout: 5, handler: nil)
    store.unsubscribe(stubSubscriber)

    XCTAssertTrue(store.state.searchCharactersState.characters.isEmpty)
  }

  func testSearchInput() {
    store = StoreHelper.storeWith(mockRoutings: [
      MockRoutingHelper.Success.characters
      ]
    )

    XCTAssertTrue(store.state.searchCharactersState.characters.isEmpty)

    let promise = expectation(description: #function)
    promise.assertForOverFulfill = false
    let stubSubscriber = StubSubscriber<AppState>(promise: promise) { state in
      return !state.searchCharactersState.characters.isEmpty
    }
    store.subscribe(stubSubscriber)
    store.dispatch(SearchCharactersFlow.didUpdateSearch(query: "test"))
    waitForExpectations(timeout: 5, handler: nil)
    store.unsubscribe(stubSubscriber)

    XCTAssertEqual(store.state.searchCharactersState.query, "test")
    XCTAssertEqual(store.state.searchCharactersState.characters.count, 20)
  }

  func testSearchNotCall() {
    store = StoreHelper.storeWith(mockRoutings: [
      MockRoutingHelper.Success.characters
      ]
    )

    XCTAssertTrue(store.state.searchCharactersState.characters.isEmpty)

    let promise = expectation(description: #function)
    promise.assertForOverFulfill = false
    let stubSubscriber = StubSubscriber<AppState>(promise: promise) { state in
      return state.searchCharactersState.query == "t"
    }
    store.subscribe(stubSubscriber)
    store.dispatch(SearchCharactersFlow.didUpdateSearch(query: "t"))
    waitForExpectations(timeout: 5, handler: nil)
    store.unsubscribe(stubSubscriber)

    XCTAssertTrue(store.state.searchCharactersState.characters.isEmpty)
  }

  func testSelectCharacter() {
    testSuccessLoadCharacters()

    XCTAssertNil(store.state.characterDetailsState.character)

    store.dispatch(SearchCharactersFlow.didSelectCharacter(at: 0))

    XCTAssertNotNil(store.state.characterDetailsState.character)
    XCTAssertEqual(store.state.characterDetailsState.character?.identifier,
                   store.state.searchCharactersState.characters[0].identifier)
  }

  func testSaveCharacter() {
    testSuccessLoadCharacters()

    XCTAssertTrue(store.state.searchCharactersState.savedCharacterIds.isEmpty)

    store.dispatch(SearchCharactersFlow.didTapSave(at: 0))

    XCTAssertFalse(store.state.searchCharactersState.savedCharacterIds.isEmpty)
    let identifier = store.state.searchCharactersState.characters[0].identifier
    XCTAssertTrue(store.state.searchCharactersState.savedCharacterIds.contains(identifier))
  }

  func testDeleteCharacter() {
    testSuccessLoadCharacters()

    XCTAssertTrue(store.state.searchCharactersState.savedCharacterIds.isEmpty)

    let identifier = store.state.searchCharactersState.characters[0].identifier
    let identifiers = Set<Int>([identifier])
    store.dispatch(SearchCharactersFlow.Actions.setSavedCharacters(identifiers))
    XCTAssertFalse(store.state.searchCharactersState.savedCharacterIds.isEmpty)

    store.dispatch(SearchCharactersFlow.didTapSave(at: 0))
    XCTAssertTrue(!store.state.searchCharactersState.savedCharacterIds.contains(identifier))
    XCTAssertTrue(store.state.searchCharactersState.savedCharacterIds.isEmpty)
  }

}
 
