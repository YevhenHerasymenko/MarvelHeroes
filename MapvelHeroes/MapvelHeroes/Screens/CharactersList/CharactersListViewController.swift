//
//  CharactersListViewController.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/30/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import UIKit
import MarvelHeroesCore

class CharactersListViewController: UITableViewController {

  struct Model: ViewModel, Equatable {

    static var initial: CharactersListViewController.Model {
      return Model()
    }
  }

  var model: Model = Model.initial {
    didSet {
      render(model)
    }
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    mainStore.dispatch(SearchCharactersFlow.reloadContent())
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mainStore.subscribe(self) { $0.select(CharactersListDataTransformer.transform) }
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    mainStore.unsubscribe(self)
  }

  private func setupView() {}

}

// MARK: - IBActions
extension CharactersListViewController {}

// MARK: - StoreSubscriber
extension CharactersListViewController: StoreSubscriber {
  func newState(state: Model) {
    model = state
  }
}

// MARK: - Model Support
extension CharactersListViewController: ViewControllerModelSupport {

  func render(_ model: Model) {}

}
