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
    return CharactersListViewController.Model.initial
  }
}
