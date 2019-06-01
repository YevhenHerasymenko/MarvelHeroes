//
//  CharacterDetailsDataTransformer.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import MarvelHeroesCore

struct CharacterDetailsDataTransformer: StateTransformer {

  static func transform(_ state: AppState) -> CharacterDetailsViewController.Model {
    guard let character = state.characterDetailsState.character else {
      return CharacterDetailsViewController.Model.initial
    }
    let description: String = {
      let description = character.description
      if description.count > 0 {
        return description
      } else {
        return NSLocalizedString("noCharacterDescription", comment: "")
      }
    }()
    return CharacterDetailsViewController.Model(
      name: character.name,
      avatar: character.thumbnail.url,
      description: description,
      isSaved: state.searchCharactersState.savedCharacterIds.contains(character.identifier),
      comics: character.comics.items.prefix(3).map { ItemTableViewCell.Model(name: $0.name) },
      events: character.events.items.prefix(3).map { ItemTableViewCell.Model(name: $0.name) },
      stories: character.stories.items.prefix(3).map { ItemTableViewCell.Model(name: $0.name) },
      series: character.series.items.prefix(3).map { ItemTableViewCell.Model(name: $0.name) })
  }
}
