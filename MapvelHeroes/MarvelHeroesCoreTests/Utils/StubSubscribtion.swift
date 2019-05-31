//
//  StubSubscribtion.swift
//  MarvelHeroesCoreTests
//
//  Created by Yevhen Herasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import XCTest
@testable import MarvelHeroesCore

class StubSubscribtion {

  let store: Store<AppState>
  let waiter = XCTWaiter()

  init(_ store: Store<AppState>) {
    self.store = store
  }

  func prepareSubscription(trigger: @escaping (AppState) -> Bool, action: (() -> Void)?) {
    let promise = XCTestExpectation(description: #function)
    promise.assertForOverFulfill = false
    let stubSubscriber = StubSubscriber<AppState>(promise: promise) { (state) -> Bool in
      return trigger(state)
    }
    store.subscribe(stubSubscriber)
    action?()
    let result = waiter.wait(for: [promise], timeout: 5)
    store.unsubscribe(stubSubscriber)
    XCTAssertTrue(result == .completed)
  }

}
