//
//  Requests.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/28/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

//https://gateway.marvel.com/v1/public/characters?ts=thesoer&apikey=001ac6c73378bbfff488a36141458af2&hash=72e5ed53d1398abb831c3ceec263f18b

//private let publicApiKey = "ffd06c2a5a79be970c70b8d0896f0316"
private let publicApiKey = "001ac6c73378bbfff488a36141458af2"
private let privateApiKey = "f032d7db9b2a20cf5025e7fe740b477857085a58"

public enum CharacterEndpoints: NetworkRouting {
  case characters(offset: Int, name: String?)
  case itemDetails(urlValue: String)

  var method: String {
    switch self {
    case .characters, .itemDetails:
      return "GET"
    }
  }

  var authPatameters: String {
    //let timestamp = "\(Int(Date().timeIntervalSince1970))"
    let timestamp = "thesoer"
    //      let hash = Crypto.MD5(string: timestamp + privateApiKey + publicApiKey)
    //        .map { String(format: "%02hhx", $0) }
    //        .joined()
    let parameters = [
      "apikey=\(publicApiKey)",
      "ts=\(timestamp)",
      // "hash=\(hash)"]
      "hash=72e5ed53d1398abb831c3ceec263f18b"]
      .compactMap { $0 }
      .joined(separator: "&")
    return parameters
  }

  var parameters: String {
    let parameters: [String?]
    switch self {
    case .characters(let offset, let name):
      parameters = [
        "offset=\(offset)",
        name.flatMap { "name=\($0)"},
        "limit=20",
        authPatameters]
    case .itemDetails:
      parameters = [authPatameters]
    }
    return parameters.compactMap { $0 }.joined(separator: "&")
  }

  var path: String {
    switch self {
    case .characters:
      let baseURL = "https://gateway.marvel.com" / "v1" / "public"
      return baseURL / "characters" + "?\(parameters)"
    case .itemDetails(let value):
      return value + "?\(parameters)"
    }
  }

  public func asURLRequest() -> URLRequest {
    guard let url = URL(string: path) else {
      fatalError("Broken url")
    }
    var request = URLRequest(url: url)
    request.httpMethod = method
    return request
  }

}
