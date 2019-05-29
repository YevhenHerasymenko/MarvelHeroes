//
//  Middleware.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/29/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

typealias MiddlewareType = SimpleMiddleware<AppState>
typealias SimpleMiddleware<State: StateType> = (Action, MiddlewareContext<State>) -> Action?

struct MiddlewareContext<State: StateType> {

  /// Closure that can be used to emit additional actions
  let dispatch: DispatchFunction
  let getState: () -> State?

  /// Closure that can be used forward your action if an async operation is performed.
  /// Just return `nil` in your middleware function in that case.
  fileprivate let next: DispatchFunction

  var state: State? {
    return getState()
  }
}

/// Creates a middlewar function using SimpleMiddleware to create a ReSwift Middleware function.
func createMiddleware<State: StateType>(_ middleware: @escaping SimpleMiddleware<State>) -> Middleware<State> {
  return { dispatch, getState in
    return { next in
      return { action in

        let context = MiddlewareContext(dispatch: dispatch, getState: getState, next: next)
        if let newAction = middleware(action, context) {
          next(newAction)
        }
      }
    }
  }
}
