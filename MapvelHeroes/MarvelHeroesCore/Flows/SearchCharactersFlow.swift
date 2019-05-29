//
//  SearchCharactersFlow.swift
//  MapvelHeroes
//
//  Created by Yevhen Herasymenko on 5/29/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

public enum SearchCharactersFlow {

  // error connects with SearchCharactersFlow
  public enum Error {
    case network(NetworkError)
  }

  /// list of action which can be required to display in UI
  public enum DisplayAction {
    case loading
    case loaded
    case error(Error)
  }

  /// Data for login scenes
  public struct State: StateType {
    /// Action for UI
    public var action: DisplayAction?
  }

  enum Reducer {}
}

extension SearchCharactersFlow {
  enum Actions: Action {
    case clear
  }
}

extension SearchCharactersFlow.Reducer {

  static func handleAction(action: Action, state: SearchCharactersFlow.State?) -> SearchCharactersFlow.State {
    var state = state ?? SearchCharactersFlow.State()
    guard let action = action as? SearchCharactersFlow.Actions else {
      return state
    }
    switch action {
    case .clear:
      state = SearchCharactersFlow.State()
    }
    return state
  }

}

/// Action Creators, state mutation
extension SearchCharactersFlow {

}
