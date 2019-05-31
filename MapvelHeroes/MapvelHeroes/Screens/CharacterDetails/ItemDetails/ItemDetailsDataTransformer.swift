//
//  ItemDetailsDataTransformer.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import MarvelHeroesCore

struct ItemDetailsDataTransformer: StateTransformer {

  static func transform(_ state: AppState) -> ItemDetailsViewController.Model {
    if let fullItem = state.characterDetailsState.item {
      return ItemDetailsViewController.Model(
        title: fullItem.title,
        imageUrl: fullItem.thumbnail?.url,
        description: fullItem.description)
    } else if let shortItem = state.characterDetailsState.shortItem {
      return ItemDetailsViewController.Model(
        title: shortItem.name,
        imageUrl: nil,
        description: nil)
    } else {
      return ItemDetailsViewController.Model.initial
    }
  }
}
