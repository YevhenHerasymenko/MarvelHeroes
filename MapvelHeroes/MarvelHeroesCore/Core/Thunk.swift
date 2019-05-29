//
//  Thunk.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/29/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

public struct Thunk<State>: Action {
  let body: (_ dispatch: @escaping DispatchFunction, _ getState: @escaping () -> State?) -> Void
  public init(body: @escaping (
    _ dispatch: @escaping DispatchFunction,
    _ getState: @escaping () -> State?) -> Void) {
    self.body = body
  }
}

@available(*, deprecated, renamed: "Thunk")
typealias ThunkAction = Thunk

public func createThunksMiddleware<State>() -> Middleware<State> {
  return { dispatch, getState in
    return { next in
      return { action in
        switch action {
        case let thunk as Thunk<State>:
          thunk.body(dispatch, getState)
        default:
          next(action)
        }
      }
    }
  }
}

// swiftlint:disable identifier_name
@available(*, deprecated, renamed: "createThunksMiddleware")
func ThunkMiddleware<State: StateType>() -> Middleware<State> {
  return createThunksMiddleware()
}
// swiftlint:enable identifier_name
