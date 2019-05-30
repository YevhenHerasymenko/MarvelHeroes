//
//  CharactersListDataTransformer.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/30/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation
import MarvelHeroesCore

struct CharactersListDataTransformer: StateTransformer {

  static func transform(_ state: AppState) -> CharactersListViewController.Model {
    let state = state.searchCharactersState

    let cells: [CharactersListTableViewCell.Model] = state.characters.enumerated().map { (index, character) in
      let isSaved = state.savedCharacterIds.contains(character.identifier)
      return CharactersListTableViewCell.Model(avatarURL: character.thumbnail.url,
                                               name: character.name,
                                               isSaved: isSaved,
                                               saveAction: {
                                                mainStore.dispatch(SearchCharactersFlow.didTapSave(at: index))
      })
    }

    return CharactersListViewController.Model(cells: cells,
                                              isAbleToPaginate: false,
                                              action: nil)
  }
}
