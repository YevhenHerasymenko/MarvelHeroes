//
//  CharacterDetailsFlow.swift
//  MapvelHeroes
//
//  Created by Yevhen Herasymenko on 5/30/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

public enum CharacterDetailsFlow {

  // error connects with CharacterDetailsFlow
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
    public var character: Character?
    public var item: ItemFull?
    public var shortItem: ItemShort?
  }

  enum Reducer {}
}

extension CharacterDetailsFlow {
  enum Actions: Action {
    case clear
    case setCharacter(Character?)
    case setItem(ItemFull?)
    case setItemShort(ItemShort?)
    case setAction(DisplayAction?)
  }
}

extension CharacterDetailsFlow.Reducer {

  static func handleAction(action: Action, state: CharacterDetailsFlow.State?) -> CharacterDetailsFlow.State {
    var state = state ?? CharacterDetailsFlow.State()
    guard let action = action as? CharacterDetailsFlow.Actions else {
      return state
    }
    switch action {
    case .clear:
      state = CharacterDetailsFlow.State()
    case .setCharacter(let character):
      state.character = character
    case .setItem(let item):
      state.item = item
    case .setItemShort(let item):
      state.shortItem = item
    case .setAction(let action):
      state.action = action
    }
    return state
  }

}

/// Action Creators, state mutation
extension CharacterDetailsFlow {

  public static func clearCharacterInfo() -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, _ in
      dispatch(Actions.setCharacter(nil))
    }
  }

  public static func clearItemInfo() -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, _ in
      dispatch(Actions.setItem(nil))
      dispatch(Actions.setItemShort(nil))
    }
  }

  public static func didSelectComics(at index: Int) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
      guard let comics = getState()?.characterDetailsState.character?.comics.items,
        comics.count > index else {
        fatalError("No state on character details")
      }
      let selectedComics = comics[index]
      dispatch(CharacterEndpoints.itemDetails(urlValue: selectedComics.resourceURI))
      dispatch(Actions.setItemShort(selectedComics))
    }
  }

  public static func didSelectEvent(at index: Int) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
      guard let events = getState()?.characterDetailsState.character?.events.items,
        events.count > index else {
          fatalError("No state on character details")
      }
      let selectedEvent = events[index]
      dispatch(CharacterEndpoints.itemDetails(urlValue: selectedEvent.resourceURI))
      dispatch(Actions.setItemShort(selectedEvent))

    }
  }

  public static func didSelectStory(at index: Int) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
      guard let stories = getState()?.characterDetailsState.character?.stories.items,
        stories.count > index else {
          fatalError("No state on character details")
      }
      let selectedStory = stories[index]
      dispatch(CharacterEndpoints.itemDetails(urlValue: selectedStory.resourceURI))
      dispatch(Actions.setItemShort(selectedStory))
    }
  }

  public static func didSelectSerie(at index: Int) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
      guard let series = getState()?.characterDetailsState.character?.series.items,
        series.count > index else {
          fatalError("No state on character details")
      }
      let selectedSerie = series[index]
      dispatch(CharacterEndpoints.itemDetails(urlValue: selectedSerie.resourceURI))
      dispatch(Actions.setItemShort(selectedSerie))
    }
  }

  public static func didTapSave() -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
      guard let character = getState()?.characterDetailsState.character else {
          fatalError()
      }
      dispatch(SearchCharactersFlow.save(character: character))
    }
  }

}
