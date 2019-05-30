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

  private enum Section: Int {
    case cells
    case loading
  }

  enum Action: Equatable {
    case loading
    case error(String)

    static func == (lhs: Action, rhs: Action) -> Bool {
      switch (lhs, rhs) {
      case (.loading, .loading),
           (.error, .error):
        return true
      default:
        return false
      }
    }
  }

  struct Model: ViewModel, Equatable {
    let cells: [CharactersListTableViewCell.Model]
    let isAbleToPaginate: Bool
    let action: Action?

    static var initial: CharactersListViewController.Model {
      return Model(cells: [], isAbleToPaginate: false, action: nil)
    }
  }

  var model: Model = Model.initial {
    didSet {
      render(model)
    }
  }

  let searchController = UISearchController(searchResultsController: nil)

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

  private func setupView() {
    tableView.tableHeaderView = UIView()
    tableView.tableFooterView = UIView()
    tableView.register(CharactersListTableViewCell.nib,
                       forCellReuseIdentifier: CharactersListTableViewCell.identifier)
    title = NSLocalizedString("characters", comment: "")

    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }

}

// MARK: - IBActions
extension CharactersListViewController {}

// MARK: - Search
extension CharactersListViewController: UISearchResultsUpdating {

  func updateSearchResults(for searchController: UISearchController) {
    mainStore.dispatch(SearchCharactersFlow.didUpdateSearch(query: searchController.searchBar.text))
  }

}

// MARK: - TableView
extension CharactersListViewController {

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = Section(rawValue: section) else {
      return 0
    }
    switch section {
    case .cells:
      return model.cells.count
    case .loading:
      return model.isAbleToPaginate ? 1 : 0
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Section(rawValue: indexPath.section) else {
      fatalError()
    }
    switch section {
    case .cells:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: CharactersListTableViewCell.identifier,
                                                     for: indexPath) as? CharactersListTableViewCell else {
        fatalError()
      }
      cell.model = model.cells[indexPath.row]
      return cell
    case .loading:
      return UITableViewCell()
    }
  }

}

// MARK: - StoreSubscriber
extension CharactersListViewController: StoreSubscriber {
  func newState(state: Model) {
    model = state
  }
}

// MARK: - Model Support
extension CharactersListViewController: ViewControllerModelSupport {

  func render(_ model: Model) {
    tableView.reloadData()
  }

}
