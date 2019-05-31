//
//  SessionManager.swift
//  MarvelHeroesCore
//
//  Created by YevhenHerasymenko on 5/28/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

extension AsyncBlockOperation: NetworkTask {}

public class SessionManager: NetworkSessionManager {
  
  private var session: URLSession
  private let networkOperationsQueue: OperationQueue

  public init() {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 20
    session = URLSession(configuration: configuration, delegate: nil, delegateQueue: .main)
    networkOperationsQueue = OperationQueue()
    networkOperationsQueue.underlyingQueue = DispatchQueue.main
  }

  /// Perform request for single object result
  public func perform<T: Codable>(request value: NetworkRouting,
                                  resultCallback: @escaping (NetworkResult<T>) -> Void) -> NetworkTask {
    let task = AsyncBlockOperation<Void> { [weak self] (operation) in
      guard !operation.isCancelled else {
        return
      }
      self?.session.dataTask(with: value.asURLRequest(), completionHandler: { (data, _, error) in
        defer {
          operation.complete()
        }
        guard !operation.isCancelled else {
          return
        }
        if let error = error {
          resultCallback(NetworkResult<T>.failure(SessionManager.parse(error: error, with: data)))
          return
        }
        guard let data = data else {
          resultCallback(NetworkResult<T>.failure(.badResponse))
          return
        }
        do {
          let object = try JSONDecoder().decode(T.self, from: data)
          resultCallback(NetworkResult<T>.success(object))
        } catch {
          resultCallback(NetworkResult<T>.failure(SessionManager.parse(error: error, with: data)))
        }
      }).resume()
    }
    networkOperationsQueue.addOperation(task)
    return task
  }

  /// Cancel all operation
  public func cancelAllOperation() {
    networkOperationsQueue.cancelAllOperations()
  }

  private static func parse(error: Error?, with data: Data?) -> NetworkError {
    guard let responseData = data, !responseData.isEmpty else {
      return error?.asNetworkError() ?? .badResponse
    }
    guard let error = try? JSONDecoder().decode(ServerError.self, from: responseData) else {
      return .parsingError
    }
    return .server(error)
  }

}
