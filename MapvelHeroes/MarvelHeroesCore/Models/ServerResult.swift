//
//  ServerResult.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/28/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

public struct ServerResult<T: Codable>: Codable {

  enum CodingKeys: String, CodingKey {
    case code
    case status
    case data
  }

  public let code: Int
  public let status: String
  public let data: ServerData<T>
}
