//
//  AppState.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/29/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

public struct AppState: StateType {
  public var searchCharactersState: SearchCharactersFlow.State
  public var characterDetailsState: CharacterDetailsFlow.State

  public enum Actions: Action {
    /// action for clear whole data in app state
    case clearData
  }
}

extension AppState {
  static func appReducer(action: Action, state: AppState?) -> AppState {
    switch action {
    case AppState.Actions.clearData:
      return AppState(
        searchCharactersState: SearchCharactersFlow.State(),
        characterDetailsState: CharacterDetailsFlow.State()
      )
    default:
      return AppState(
        searchCharactersState: SearchCharactersFlow.Reducer.handleAction(action: action,
                                                                         state: state?.searchCharactersState),
        characterDetailsState: CharacterDetailsFlow.Reducer.handleAction(action: action, state:
          state?.characterDetailsState)
      )
    }
  }
}

public func createStore(_ sessionManager: NetworkSessionManager,
                        _ persistentContainer: PersistentManager) -> Store<AppState> {
  return Store<AppState>(
    reducer: AppState.appReducer,
    state: nil,
    middleware: [createThunksMiddleware(),
                 createMiddleware(NetworkMiddleware.network(service: sessionManager)),
                 createMiddleware(PersistenceMiddleware.persistance(service: persistentContainer))]
  )
}

extension AppState {

  /// clear all state data
  public static func clearData() -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, _ in
      dispatch(Actions.clearData)
    }
  }

}
