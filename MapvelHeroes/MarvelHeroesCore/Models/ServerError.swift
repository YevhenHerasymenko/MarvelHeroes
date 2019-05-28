//
//  ServerError.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/28/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

/// Model for showing server error
public struct ServerError: Codable, Equatable {

  enum CodingKeys: String, CodingKey {
    case status
    case code
  }

  /// error message
  public let status: String?
  /// error code
  public let code: Int
}
