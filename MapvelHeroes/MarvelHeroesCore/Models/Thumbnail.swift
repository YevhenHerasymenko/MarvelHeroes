//
//  Thumbnail.swift
//  MarvelHeroesCore
//
//  Created by YevhenHerasymenko on 5/29/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

public struct Thumbnail: Codable {

  enum CodingKeys: String, CodingKey {
    case path
    case pathExtension = "extension"
  }

  let path: String
  let pathExtension: String

  public var url: URL {
    guard let url = URL(string: path + "." + pathExtension) else {
      fatalError("\(self) cannot provide correct url")
    }
    return url
  }
}
