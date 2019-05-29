//
//  NetworkMiddleware.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/29/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

enum NetworkActions: Action {
  case characters
}

enum NetworkMiddleware {

  static func network(service: NetworkSessionManager) -> MiddlewareType {
    return { network(action: $0, context: $1, service: service) }
  }

}

extension NetworkMiddleware {

  private static func network(action: Action,
                              context: MiddlewareContext<AppState>,
                              service: NetworkSessionManager) -> Action? {
    guard let networkAction = action as? NetworkActions else {
      return action
    }
    switch networkAction {
    case .characters:
      return nil
    }
  }

}
