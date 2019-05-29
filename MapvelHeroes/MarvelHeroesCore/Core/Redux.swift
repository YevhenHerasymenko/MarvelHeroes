//
//  Redux.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/29/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

/// All actions that want to be able to be dispatched to a store need to conform to this protocol
/// Currently it is just a marker protocol with no requirements.
public protocol Action { }

/// Initial Action that is dispatched as soon as the store is created.
/// Reducers respond to this action by configuring their intial state.
public struct ReduxInit: Action {}

// MARK: - State
public protocol StateType { }

// MARK: - Reducer
public typealias Reducer<ReducerStateType> =
  (_ action: Action, _ state: ReducerStateType?) -> ReducerStateType

// MARK: - Middleware
public typealias DispatchFunction = (Action) -> Void
public typealias Middleware<State> = (@escaping DispatchFunction, @escaping () -> State?)
  -> (@escaping DispatchFunction) -> DispatchFunction

// MARK: - StoreSubscriber
public protocol AnyStoreSubscriber: class {
  // swiftlint:disable:next identifier_name
  func _newState(state: Any)
}

public protocol StoreSubscriber: AnyStoreSubscriber {
  associatedtype StoreSubscriberStateType

  func newState(state: StoreSubscriberStateType)
}

extension StoreSubscriber {
  // swiftlint:disable:next identifier_name
  public func _newState(state: Any) {
    if let typedState = state as? StoreSubscriberStateType {
      newState(state: typedState)
    }
  }
}
