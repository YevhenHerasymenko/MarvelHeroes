//
//  StateTransformer.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/30/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import MarvelHeroesCore

/// Protocol for explanation how to create view controller state from app state
protocol StateTransformer {
  associatedtype ViewState: ViewModel
  /// Main function for transformation AppState to ViewState
  static func transform(_ state: AppState) -> ViewState
  /// Function for filtering same ViewStates
  static func filter(old: ViewState, new: ViewState) -> Bool
}

extension StateTransformer {

  /// Default realization for filter
  public static func filter(old: ViewState, new: ViewState) -> Bool {
    return false
  }

}
