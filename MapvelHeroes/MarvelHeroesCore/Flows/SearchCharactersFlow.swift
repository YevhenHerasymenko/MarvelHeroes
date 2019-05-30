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
    case error(Error)
  }

  /// Data for login scenes
  public struct State: StateType {
    /// Action for UI
    public var action: DisplayAction?
    public var characters: [Character] = []
    public var savedCharacterIds: [Int] = []
    public var total: Int = 0
    public var query: String?
  }

  enum Reducer {}
}

extension SearchCharactersFlow {
  enum Actions: Action {
    case clear
    case setCharacters([Character], isReload: Bool)
    case setTotal(Int)
    case setAction(DisplayAction?)
    case setQuery(String?)
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
    case .setCharacters(let characters, let isReload):
      if isReload {
        state.characters = characters
      } else {
        var newCharacters = state.characters
        newCharacters.append(contentsOf: characters)
        state.characters = characters
      }
    case .setTotal(let total):
      state.total = total
    case .setAction(let action):
      state.action = action
    case .setQuery(let query):
      state.query = query
    }
    return state
  }

}

/// Action Creators, state mutation
extension SearchCharactersFlow {

  public static func reloadContent() -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, _ in
      dispatch(CharacterEndpoints.characters(offset: 0, name: nil))
    }
  }

  public static func didUpdateSearch(query: String?) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, _ in
      dispatch(Actions.setQuery(query))
      if let query = query {
        guard query.count > 2 else {
          return
        }
        dispatch(CharacterEndpoints.characters(offset: 0, name: query))
      } else {
        dispatch(CharacterEndpoints.characters(offset: 0, name: nil))
      }
    }
  }

  public static func paginateIfNeeded() -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
      guard let state = getState()?.searchCharactersState else {
        fatalError("No state when call pagination")
      }
      guard state.characters.count < state.total, state.action == nil else {
        return
      }
      dispatch(CharacterEndpoints.characters(offset: state.characters.count, name: state.query))
    }
  }

  public static func didTapSave(at index: Int) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, _ in
      
    }
  }

  public static func didHandleAction() -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, _ in
      dispatch(Actions.setAction(nil))
    }
  }

}
