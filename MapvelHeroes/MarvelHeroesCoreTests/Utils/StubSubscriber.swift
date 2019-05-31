//
//  StubSubscriber.swift
//  MarvelHeroesCoreTests
//
//  Created by Yevhen Herasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import XCTest
@testable import MarvelHeroesCore

class StubSubscriber<T>: StoreSubscriber {
  typealias StoreSubscriberStateType = T
  let promise: XCTestExpectation
  let promiseTrigger: (T) -> Bool

  init(promise: XCTestExpectation, promiseTrigger: @escaping (T) -> Bool) {
    self.promise = promise
    self.promiseTrigger = promiseTrigger
  }

  func newState(state: T) {
    if promiseTrigger(state) {
      promise.fulfill()
    }
  }
}
