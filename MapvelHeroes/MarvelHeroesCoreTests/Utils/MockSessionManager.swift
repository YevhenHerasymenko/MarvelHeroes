//
//  MockSessionManager.swift
//  MarvelHeroesCoreTests
//
//  Created by Yevhen Herasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

@testable import MarvelHeroesCore
import Foundation
import XCTest

//extension AsyncBlockOperation: NetworkTask {}

enum MockFile: String {
  // login mocks
  case characters
  case item
  case error
}

struct MockRouting {
  enum Result {
    case success(fileName: MockFile)
    case serverError(fileName: MockFile)
    case customError(NetworkError)
  }

  let routing: NetworkRouting
  let result: Result

  func isEqualTo(otherRouting: NetworkRouting) -> Bool {
    switch (routing, otherRouting) {
    case (CharacterEndpoints.characters, CharacterEndpoints.characters),
         (CharacterEndpoints.itemDetails, CharacterEndpoints.itemDetails):
      return true
    default:
      return false
    }
  }
}

class MockSessionManager: NetworkSessionManager {
  private let scenarios: [MockRouting]
  private let networkOperationsQueue: OperationQueue

  init(scenarios: [MockRouting]) {
    self.scenarios = scenarios
    networkOperationsQueue = OperationQueue()
    networkOperationsQueue.underlyingQueue = DispatchQueue.main
  }

  func perform<T: Codable>(request value: NetworkRouting,
                           resultCallback: @escaping (NetworkResult<T>) -> Void) -> NetworkTask {
    let request = value.asURLRequest()
    guard let scenario = scenarios.first(where: { $0.isEqualTo(otherRouting: value) }) else {
      fatalError("can't find scenario for requset: \(request)")
    }
    let task = AsyncBlockOperation<Void> { (operation) in
      defer {
        operation.complete()
      }
      switch scenario.result {
      case .success(let fileName):
        do {
          let json = self.loadObject(from: fileName)
          let data = try JSONSerialization.data(withJSONObject: json, options: [])
          let object = try JSONDecoder().decode(T.self, from: data)
          resultCallback(NetworkResult<T>.success(object))
        } catch {
          XCTFail("can't parse response for: \(fileName.rawValue)")
        }
      case .serverError(let fileName):
        do {
          let json = self.loadObject(from: fileName)
          let data = try JSONSerialization.data(withJSONObject: json, options: [])
          let object = try JSONDecoder().decode(ServerError.self, from: data)
          resultCallback(NetworkResult<T>.failure(.server(object)))
        } catch {
          XCTFail("can't parse response for: \(fileName.rawValue)")
        }
      case .customError(let error):
        resultCallback(NetworkResult<T>.failure(error))
      }
    }
    networkOperationsQueue.addOperation(task)
    return task
  }

  private func loadObject(from file: MockFile) -> [String: AnyObject] {
    guard let dataURL = Bundle(for: type(of: self)).url(forResource: file.rawValue, withExtension: "json"),
      let data = try? Data(contentsOf: dataURL) else {
        XCTFail("can't load data from file: \(file.rawValue)")
        return [:]
    }
    guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
      let dict = json as? [String: AnyObject] else {
        XCTFail("can't parse json from file: \(file.rawValue)")
        return [:]
    }
    return dict
  }

  private func loadObjectArray(from file: MockFile) -> [[String: AnyObject]] {
    guard let dataURL = Bundle(for: type(of: self)).url(forResource: file.rawValue, withExtension: "json"),
      let data = try? Data(contentsOf: dataURL) else {
        XCTFail("can't load data from file: \(file.rawValue)")
        return []
    }
    guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
      let dict = json as? [[String: AnyObject]] else {
        XCTFail("can't parse json from file: \(file.rawValue)")
        return []
    }
    return dict
  }

  func cancelAllOperation() {}

}
