//
//  Requests.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/28/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

private let publicApiKey = "ffd06c2a5a79be970c70b8d0896f0316"
private let privateApiKey = "f032d7db9b2a20cf5025e7fe740b477857085a58"

enum CharacterEndpoints {
  case characters(offset: Int, name: String?)

  var method: String {
    switch self {
    case .characters:
      return "GET"
    }
  }

  var path: String {
    let baseURL = "https://gateway.marvel.com:443" / "v1" / "public"
    switch self {
    case .characters(let offset, let name):
      let timestamp = "\(Int(Date().timeIntervalSince1970))"
      let hash = Crypto.MD5(string: timestamp + privateApiKey + publicApiKey)
        .map { String(format: "%02hhx", $0) }
        .joined()
      let parameters = [
        "offset = \(offset)",
        name.flatMap { "name=\($0)"},
        "limit=20",
        "apikey=\(publicApiKey)",
        "ts=\(timestamp)",
        "hash=\(hash)"]
        .compactMap { $0 }
        .joined(separator: "&")
      return baseURL / "characters" + "?\(parameters)"
    }
  }

  func asURLRequest() -> URLRequest {
    guard let url = URL(string: path) else {
      fatalError("Broken url")
    }
    var request = URLRequest(url: url)
    request.httpMethod = method
    return request
  }

}
