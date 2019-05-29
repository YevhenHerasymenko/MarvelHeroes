//
//  Character.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/28/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

public struct Character: Codable {

  enum CodingKeys: String, CodingKey {
    case name
    case description
    case thumbnail
    case comics
    case series
    case stories
    case events
  }

  public let name: String
  public let description: String
  public let thumbnail: Thumbnail
  public let comics: ItemsList
  public let series: ItemsList
  public let stories: ItemsList
  public let events: ItemsList
}
