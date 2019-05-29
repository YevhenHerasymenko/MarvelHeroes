//
//  Store.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/29/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

public protocol DispatchingStoreType {

  /**
   Dispatches an action. This is the simplest way to modify the stores state.
   - parameter action: The action that is being dispatched to the store
   */
  func dispatch(_ action: Action)
}

public protocol StoreType: DispatchingStoreType {

  associatedtype State: StateType

  /// The current state stored in the store.
  var state: State! { get }

  /**
   The main dispatch function that is used by all convenience `dispatch` methods.
   This dispatch function can be extended by providing middlewares.
   */
  var dispatchFunction: DispatchFunction! { get }

  /**
   Subscribes the provided subscriber to this store.
   Subscribers will receive a call to `newState` whenever the
   state in this store changes.

   - parameter subscriber: Subscriber that will receive store updates
   - note: Subscriptions are not ordered, so an order of state updates cannot be guaranteed.
   */
  func subscribe<S: StoreSubscriber>(_ subscriber: S) where S.StoreSubscriberStateType == State

  /**
   Subscribes the provided subscriber to this store.
   Subscribers will receive a call to `newState` whenever the
   state in this store changes and the subscription decides to forward
   state update.

   - parameter subscriber: Subscriber that will receive store updates
   - parameter transform: A closure that receives a simple subscription and can return a
   transformed subscription. Subscriptions can be transformed to only select a subset of the
   state, or to skip certain state updates.
   - note: Subscriptions are not ordered, so an order of state updates cannot be guaranteed.
   */
  func subscribe<SelectedState, S: StoreSubscriber>(
    _ subscriber: S, transform: ((Subscription<State>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

  /**
   Unsubscribes the provided subscriber. The subscriber will no longer
   receive state updates from this store.

   - parameter subscriber: Subscriber that will be unsubscribed
   */
  func unsubscribe(_ subscriber: AnyStoreSubscriber)

  func dispatch(_ actionCreator: ActionCreator)

  associatedtype ActionCreator = (_ state: State, _ store: StoreType) -> Action?
}

// MARK: - Store
open class Store<State: StateType>: StoreType {

  typealias SubscriptionType = SubscriptionBox<State>

  public var state: State! {
    didSet {
      subscriptions.forEach {
        if $0.subscriber == nil {
          subscriptions.remove($0)
        } else {
          $0.newValues(oldState: oldValue, newState: state)
        }
      }
    }
  }

  public var dispatchFunction: DispatchFunction!

  private var reducer: Reducer<State>

  var subscriptions: Set<SubscriptionType> = []

  private var isDispatching = false

  /// Indicates if new subscriptions attempt to apply `skipRepeats`
  /// by default.
  fileprivate let subscriptionsAutomaticallySkipRepeats: Bool

  /// Initializes the store with a reducer, an initial state and a list of middleware.
  ///
  /// Middleware is applied in the order in which it is passed into this constructor.
  ///
  /// - parameter reducer: Main reducer that processes incoming actions.
  /// - parameter state: Initial state, if any. Can be `nil` and will be
  ///   provided by the reducer in that case.
  /// - parameter middleware: Ordered list of action pre-processors, acting
  ///   before the root reducer.
  /// - parameter automaticallySkipsRepeats: If `true`, the store will attempt
  ///   to skip idempotent state updates when a subscriber's state type
  ///   implements `Equatable`. Defaults to `true`.
  public required init(
    reducer: @escaping Reducer<State>,
    state: State?,
    middleware: [Middleware<State>] = [],
    automaticallySkipsRepeats: Bool = true
    ) {
    self.subscriptionsAutomaticallySkipRepeats = automaticallySkipsRepeats
    self.reducer = reducer

    // Wrap the dispatch function with all middlewares
    self.dispatchFunction = middleware
      .reversed()
      .reduce(
        { [unowned self] action in
          self._defaultDispatch(action: action) },
        { dispatchFunction, middleware in
          // If the store get's deinitialized before the middleware is complete; drop
          // the action without dispatching.
          let dispatch: (Action) -> Void = { [weak self] in self?.dispatch($0) }
          let getState = { [weak self] in self?.state }
          return middleware(dispatch, getState)(dispatchFunction)
      })

    if let state = state {
      self.state = state
    } else {
      dispatch(ReduxInit())
    }
  }

  fileprivate func _subscribe<SelectedState, S: StoreSubscriber>(
    _ subscriber: S, originalSubscription: Subscription<State>,
    transformedSubscription: Subscription<SelectedState>?)
    where S.StoreSubscriberStateType == SelectedState
  {
    let subscriptionBox = self.subscriptionBox(
      originalSubscription: originalSubscription,
      transformedSubscription: transformedSubscription,
      subscriber: subscriber
    )

    subscriptions.update(with: subscriptionBox)

    if let state = self.state {
      originalSubscription.newValues(oldState: nil, newState: state)
    }
  }

  open func subscribe<S: StoreSubscriber>(_ subscriber: S)
    where S.StoreSubscriberStateType == State {
      _ = subscribe(subscriber, transform: nil)
  }

  open func subscribe<SelectedState, S: StoreSubscriber>(
    _ subscriber: S, transform: ((Subscription<State>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
  {
    // Create a subscription for the new subscriber.
    let originalSubscription = Subscription<State>()
    // Call the optional transformation closure. This allows callers to modify
    // the subscription, e.g. in order to subselect parts of the store's state.
    let transformedSubscription = transform?(originalSubscription)

    _subscribe(subscriber, originalSubscription: originalSubscription,
               transformedSubscription: transformedSubscription)
  }

  func subscriptionBox<T>(
    originalSubscription: Subscription<State>,
    transformedSubscription: Subscription<T>?,
    subscriber: AnyStoreSubscriber
    ) -> SubscriptionBox<State> {

    return SubscriptionBox(
      originalSubscription: originalSubscription,
      transformedSubscription: transformedSubscription,
      subscriber: subscriber
    )
  }

  open func unsubscribe(_ subscriber: AnyStoreSubscriber) {
    if let index = subscriptions.firstIndex(where: { return $0.subscriber === subscriber }) {
      subscriptions.remove(at: index)
    }
  }

  // swiftlint:disable:next identifier_name
  open func _defaultDispatch(action: Action) {
    guard !isDispatching else {
      fatalError()
    }

    isDispatching = true
    let newState = reducer(action, state)
    isDispatching = false

    state = newState
  }

  open func dispatch(_ action: Action) {
    dispatchFunction(action)
  }
}

// MARK: Skip Repeats for Equatable States

extension Store {
  open func subscribe<SelectedState: Equatable, S: StoreSubscriber>(
    _ subscriber: S, transform: ((Subscription<State>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
  {
    let originalSubscription = Subscription<State>()

    var transformedSubscription = transform?(originalSubscription)
    if subscriptionsAutomaticallySkipRepeats {
      transformedSubscription = transformedSubscription?.skipRepeats()
    }
    _subscribe(subscriber, originalSubscription: originalSubscription,
               transformedSubscription: transformedSubscription)
  }
}

extension Store where State: Equatable {
  open func subscribe<S: StoreSubscriber>(_ subscriber: S)
    where S.StoreSubscriberStateType == State {
      guard subscriptionsAutomaticallySkipRepeats else {
        _ = subscribe(subscriber, transform: nil)
        return
      }
      _ = subscribe(subscriber, transform: { $0.skipRepeats() })
  }
}
