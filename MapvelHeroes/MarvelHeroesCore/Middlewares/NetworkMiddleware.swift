//
//  NetworkMiddleware.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/29/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation

enum NetworkMiddleware {

  static func network(service: NetworkSessionManager) -> MiddlewareType {
    return { network(action: $0, context: $1, service: service) }
  }

}

extension NetworkMiddleware {

  private static func network(action: Action,
                              context: MiddlewareContext<AppState>,
                              service: NetworkSessionManager) -> Action? {
    guard let networkAction = action as? CharacterEndpoints else {
      return action
    }
    switch networkAction {
    case .characters:
      service.perform(request: networkAction) { (result: NetworkResult<ServerResult<Character>>) in
        switch result {
        case .success(let serverResult):
          context.dispatch(SearchCharactersFlow.Actions.setTotal(serverResult.data.total))
          let isReload = serverResult.data.offset == 0
          context.dispatch(SearchCharactersFlow.Actions.setCharacters(serverResult.data.results, isReload: isReload))
          context.dispatch(SearchCharactersFlow.Actions.setAction(nil))
        case .failure(let error):
          context.dispatch(SearchCharactersFlow.Actions.setAction(.error(.network(error))))
        }
      }
      context.dispatch(SearchCharactersFlow.Actions.setAction(.loading))
    case .itemDetails(let urlValue):
      print(urlValue)
    }
    return nil
  }

}
