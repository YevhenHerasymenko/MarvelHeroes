//
//  NetworkSessionManager.swift
//  MarvelHeroesCore
//
//  Created by YevhenHerasymenko on 5/28/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

/**
 Protocol for routers. Protocol expands URLRequestConvertible which Alamofire uses for requsts with MockableRequest
 which allows profide mock files for testing
 */
public protocol NetworkRouting {
  func asURLRequest() -> URLRequest
}

/// Protocol for descrabing network tast
public protocol NetworkTask: class {
  /// Flag shows if task is cancelled
  var isCancelled: Bool { get }
  /// triger for cancelling network task
  func cancel()
}

/**
 Protocol describes basic functions for Session managers it provides opportunity to create specific session manager
 for unit testing or etc
 */
public protocol NetworkSessionManager {

  /// method for request with simple object in response
  @discardableResult func perform<T: Codable>(
    request value: NetworkRouting,
    resultCallback: @escaping (NetworkResult<T>) -> Void) -> NetworkTask
  
  /// cancel all operation
  func cancelAllOperation()
}

/// Network Result. Generic Enum for server response
public enum NetworkResult<T> {

  /// with generic type
  case success(T)

  /// case for errors in response
  case failure(NetworkError)
}
