//
//  ServerData.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/28/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

public struct ServerData<T: Codable>: Codable {

  enum CodingKeys: String, CodingKey {
    case offset
    case limit
    case total
    case count
    case results
  }

  public let offset: Int
  public let limit: Int
  public let total: Int
  public let count: Int
  public let results: [T]
}
