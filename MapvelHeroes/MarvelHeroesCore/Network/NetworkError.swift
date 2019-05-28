//
//  NetworkError.swift
//  MarvelHeroesCore
//
//  Created by YevhenHerasymenko on 5/28/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

/// List of network errors
public enum NetworkError: Error, Equatable {
  /// no internet
  case noInternetConnection
  /// timeout (time can be different for different requests)
  case timeout
  /// unexpected response
  case badResponse
  /// error during generation app model from server response (JSON)
  case parsingError
  /// particular error from server side
  case server(ServerError)
  /// the others cases
  case unknown
}

extension Error {

  func asNetworkError() -> NetworkError {
    switch (self as NSError).code {
    case NSURLErrorNotConnectedToInternet:
      return .noInternetConnection
    case NSURLErrorTimedOut:
      return .timeout
    default:
      return .unknown
    }
  }

}
