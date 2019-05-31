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
    return CharacterDetailsViewController.Model(
      name: character.name,
      avatar: character.thumbnail.url,
      description: character.description,
      comics: character.comics.items.prefix(3).map { ItemTableViewCell.Model(name: $0.name) },
      events: character.events.items.prefix(3).map { ItemTableViewCell.Model(name: $0.name) },
      stories: character.stories.items.prefix(3).map { ItemTableViewCell.Model(name: $0.name) },
      series: character.series.items.prefix(3).map { ItemTableViewCell.Model(name: $0.name) })
  }
}
