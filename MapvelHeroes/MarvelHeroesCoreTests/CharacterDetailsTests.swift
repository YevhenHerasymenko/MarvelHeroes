//
//  CharacterDetailsTests.swift
//  MarvelHeroesCoreTests
//
//  Created by Yevhen Herasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import XCTest
@testable import MarvelHeroesCore

private extension Character {

  static var mock: Character {
    return Character(identifier: 1,
                     name: "Test",
                     description: "desc",
                     thumbnail: Thumbnail(path: "", pathExtension: ""),
                     comics: ItemsList(items: [ItemShort(resourceURI: "", name: "item")]),
                     series: ItemsList(items: [ItemShort(resourceURI: "", name: "item")]),
                     stories: ItemsList(items: [ItemShort(resourceURI: "", name: "item")]),
                     events: ItemsList(items: [ItemShort(resourceURI: "", name: "item")]))
  }

}

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

  func testSuccessLoadEventItem() {
    store = StoreHelper.storeWith(mockRoutings: [
      MockRoutingHelper.Success.item
      ]
    )

    let character = Character.mock
    store.dispatch(CharacterDetailsFlow.Actions.setCharacter(character))

    XCTAssertNil(store.state.characterDetailsState.item)

    let promise = expectation(description: #function)
    promise.assertForOverFulfill = false
    let stubSubscriber = StubSubscriber<AppState>(promise: promise) { state in
      return state.characterDetailsState.item != nil
    }
    store.subscribe(stubSubscriber)
    store.dispatch(CharacterDetailsFlow.didSelectEvent(at: 0))
    waitForExpectations(timeout: 5, handler: nil)
    store.unsubscribe(stubSubscriber)

    XCTAssertNotNil(store.state.characterDetailsState.shortItem)
    XCTAssertNotNil(store.state.characterDetailsState.item)
  }

  func testSuccessLoadComicsItem() {
    store = StoreHelper.storeWith(mockRoutings: [
      MockRoutingHelper.Success.item
      ]
    )

    let character = Character.mock
    store.dispatch(CharacterDetailsFlow.Actions.setCharacter(character))

    XCTAssertNil(store.state.characterDetailsState.item)

    let promise = expectation(description: #function)
    promise.assertForOverFulfill = false
    let stubSubscriber = StubSubscriber<AppState>(promise: promise) { state in
      return state.characterDetailsState.item != nil
    }
    store.subscribe(stubSubscriber)
    store.dispatch(CharacterDetailsFlow.didSelectComics(at: 0))
    waitForExpectations(timeout: 5, handler: nil)
    store.unsubscribe(stubSubscriber)

    XCTAssertNotNil(store.state.characterDetailsState.shortItem)
    XCTAssertNotNil(store.state.characterDetailsState.item)
  }

  func testSuccessLoadStoryItem() {
    store = StoreHelper.storeWith(mockRoutings: [
      MockRoutingHelper.Success.item
      ]
    )

    let character = Character.mock
    store.dispatch(CharacterDetailsFlow.Actions.setCharacter(character))

    XCTAssertNil(store.state.characterDetailsState.item)

    let promise = expectation(description: #function)
    promise.assertForOverFulfill = false
    let stubSubscriber = StubSubscriber<AppState>(promise: promise) { state in
      return state.characterDetailsState.item != nil
    }
    store.subscribe(stubSubscriber)
    store.dispatch(CharacterDetailsFlow.didSelectStory(at: 0))
    waitForExpectations(timeout: 5, handler: nil)
    store.unsubscribe(stubSubscriber)

    XCTAssertNotNil(store.state.characterDetailsState.shortItem)
    XCTAssertNotNil(store.state.characterDetailsState.item)
  }

  func testSuccessLoadSeriesItem() {
    store = StoreHelper.storeWith(mockRoutings: [
      MockRoutingHelper.Success.item
      ]
    )

    let character = Character.mock
    store.dispatch(CharacterDetailsFlow.Actions.setCharacter(character))

    XCTAssertNil(store.state.characterDetailsState.item)

    let promise = expectation(description: #function)
    promise.assertForOverFulfill = false
    let stubSubscriber = StubSubscriber<AppState>(promise: promise) { state in
      return state.characterDetailsState.item != nil
    }
    store.subscribe(stubSubscriber)
    store.dispatch(CharacterDetailsFlow.didSelectSerie(at: 0))
    waitForExpectations(timeout: 5, handler: nil)
    store.unsubscribe(stubSubscriber)

    XCTAssertNotNil(store.state.characterDetailsState.shortItem)
    XCTAssertNotNil(store.state.characterDetailsState.item)
  }

  func testFailLoadItem() {
    store = StoreHelper.storeWith(mockRoutings: [
      MockRoutingHelper.Fail.item
      ]
    )

    let character = Character.mock
    store.dispatch(CharacterDetailsFlow.Actions.setCharacter(character))

    let promise = expectation(description: #function)
    promise.assertForOverFulfill = false
    let stubSubscriber = StubSubscriber<AppState>(promise: promise) { state in
      if case .some(.error) = state.characterDetailsState.action {
        return true
      } else {
        return false
      }
    }
    store.subscribe(stubSubscriber)
    store.dispatch(CharacterDetailsFlow.didSelectEvent(at: 0))
    waitForExpectations(timeout: 5, handler: nil)
    store.unsubscribe(stubSubscriber)

    XCTAssertNotNil(store.state.characterDetailsState.shortItem)
    XCTAssertNil(store.state.characterDetailsState.item)
  }

  func testSaveCharacter() {
    store = StoreHelper.emptyStore
    let character = Character.mock
    store.dispatch(CharacterDetailsFlow.Actions.setCharacter(character))

    XCTAssertTrue(store.state.searchCharactersState.savedCharacterIds.isEmpty)

    store.dispatch(CharacterDetailsFlow.didTapSave())

    XCTAssertFalse(store.state.searchCharactersState.savedCharacterIds.isEmpty)
    let identifier = character.identifier
    XCTAssertTrue(store.state.searchCharactersState.savedCharacterIds.contains(identifier))
  }

  func testDeleteCharacter() {
    store = StoreHelper.emptyStore
    let character = Character.mock
    store.dispatch(CharacterDetailsFlow.Actions.setCharacter(character))

    XCTAssertTrue(store.state.searchCharactersState.savedCharacterIds.isEmpty)

    let identifier = character.identifier
    let identifiers = Set<Int>([identifier])
    store.dispatch(SearchCharactersFlow.Actions.setSavedCharacters(identifiers))
    XCTAssertFalse(store.state.searchCharactersState.savedCharacterIds.isEmpty)

    store.dispatch(CharacterDetailsFlow.didTapSave())
    XCTAssertTrue(!store.state.searchCharactersState.savedCharacterIds.contains(identifier))
    XCTAssertTrue(store.state.searchCharactersState.savedCharacterIds.isEmpty)
  }

  func testClearCharacterInfo() {
    store = StoreHelper.emptyStore
    let character = Character.mock
    store.dispatch(CharacterDetailsFlow.Actions.setCharacter(character))

    XCTAssertNotNil(store.state.characterDetailsState.character)
    store.dispatch(CharacterDetailsFlow.clearCharacterInfo())
    XCTAssertNil(store.state.characterDetailsState.character)
  }

  func testClearItemInfo() {
    store = StoreHelper.emptyStore
    let shortItem = ItemShort(resourceURI: "", name: "")
    let item = ItemFull(title: "test", description: nil, thumbnail: nil)
    store.dispatch(CharacterDetailsFlow.Actions.setItemShort(shortItem))
    store.dispatch(CharacterDetailsFlow.Actions.setItem(item))

    XCTAssertNotNil(store.state.characterDetailsState.shortItem)
    XCTAssertNotNil(store.state.characterDetailsState.item)
    store.dispatch(CharacterDetailsFlow.clearItemInfo())
    XCTAssertNil(store.state.characterDetailsState.shortItem)
    XCTAssertNil(store.state.characterDetailsState.item)
  }

}
