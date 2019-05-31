//
//  ItemShort.swift
//  MarvelHeroesCore
//
//  Created by YevhenHerasymenko on 5/29/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

public struct ItemsList: Codable {

  enum CodingKeys: String, CodingKey {
    case items
  }

  public let items: [ItemShort]
}

public struct ItemShort: Codable {

  enum CodingKeys: String, CodingKey {
    case resourceURI
    case name
  }

  public let resourceURI: String
  public let name: String
}

public struct ItemFull: Codable {

  enum CodingKeys: String, CodingKey {
    case title
    case description
    case thumbnail
  }

  public let title: String
  public let description: String?
  public let thumbnail: Thumbnail?
}
