//
//  ViewController.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/28/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import UIKit
import MarvelHeroesCore

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let request = CharacterEndpoints.characters(offset: 0, name: nil)
    SessionManager().perform(request: request) { (result: NetworkResult<ServerResult<Character>>) in
      switch result {
      case .success(let serverResult):
        print(serverResult)
      case .failure(let error):
        print(error)
      }
    }
  }


}

