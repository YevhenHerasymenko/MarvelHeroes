//
//  AsyncBlockOperation.swift
//  MarvelHeroesCore
//
//  Created by YevhenHerasymenko on 5/28/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

/// Block operation to have ability to manipulate of execution process
public class AsyncBlockOperation<T>: Operation {
  /// Operation signature
  public typealias AsyncBlock = (_ block: AsyncBlockOperation) -> Void
  var block: AsyncBlock?
  /// Operation result
  public var result: T?
  // MARK: - Initializers

  /// Public constructor
  public init(with block: @escaping AsyncBlock) {
    super.init()

    self.block = block
  }

  // MARK: - Override

  private var _isExecuting: Bool = false
  private var _isFinished: Bool = false

  /// always concurrent
  override public var isConcurrent: Bool {
    return true
  }

  /// Indicate operation is executing or not
  override public var isExecuting: Bool {
    return _isExecuting
  }

  /// Indicate operation was finished or not
  override public var isFinished: Bool {
    return _isFinished
  }

  /// Start operation
  override public func start() {
    guard isCancelled == false else {
      willChangeValue(forKey: "isFinished")
      _isFinished = true
      didChangeValue(forKey: "isFinished")

      return
    }

    willChangeValue(forKey: "isExecuting")
    _isExecuting = true
    didChangeValue(forKey: "isExecuting")

    if let block = self.block {
      block(self)
    } else {
      complete()
    }
  }

  // MARK: - Interface

  /// Complete operation
  public func complete() {
    willChangeValue(forKey: "isExecuting")
    willChangeValue(forKey: "isFinished")

    _isExecuting = false
    _isFinished = true

    didChangeValue(forKey: "isExecuting")
    didChangeValue(forKey: "isFinished")
  }
}
