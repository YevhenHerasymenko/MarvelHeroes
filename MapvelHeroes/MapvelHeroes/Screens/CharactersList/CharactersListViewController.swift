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

  private enum Segue: String {
    case showCharacter
  }

  private enum Section: Int {
    case cells
    case loading
  }

  struct Model: ViewModel, Equatable {
    let cells: [CharactersListTableViewCell.Model]
    let isAbleToPaginate: Bool
    let error: String?

    static var initial: CharactersListViewController.Model {
      return Model(cells: [], isAbleToPaginate: false, error: nil)
    }
  }

  var model: Model = Model.initial {
    didSet {
      render(model)
    }
  }

  let searchController = UISearchController(searchResultsController: nil)

  private var selectedImage: UIImage?
  private var selectedFrame: CGRect?
  private var customInteractor: TransitionInteractor?

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
    navigationController?.delegate = self
    tableView.tableHeaderView = UIView()
    tableView.tableFooterView = UIView()
    tableView.register(CharactersListTableViewCell.nib,
                       forCellReuseIdentifier: CharactersListTableViewCell.identifier)
    tableView.register(PaginationTableViewCell.nib,
                       forCellReuseIdentifier: PaginationTableViewCell.identifier)
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
      guard let cell = tableView.dequeueReusableCell(withIdentifier: PaginationTableViewCell.identifier,
                                                     for: indexPath) as? PaginationTableViewCell else {
                                                      fatalError()
      }
      cell.model = .init()
      return cell
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let section = Section(rawValue: indexPath.section),
      section == .cells,
      let cell = tableView.cellForRow(at: indexPath) as? CharactersListTableViewCell else {
      return
    }
    selectedFrame = cell.convert(cell.avatarView.frame, to: nil)
    selectedImage = cell.avatarView.image
    mainStore.dispatch(SearchCharactersFlow.didSelectCharacter(at: indexPath.row))
    performSegue(withIdentifier: Segue.showCharacter.rawValue, sender: nil)
  }

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let section = Section(rawValue: indexPath.section),
      section == .loading,
      let cell = cell as? PaginationTableViewCell else {
      return
    }
    cell.activityIndicator.startAnimating()
    mainStore.dispatch(SearchCharactersFlow.paginateIfNeeded())
  }

}

// MARK: - Bavigation controller delegate
extension CharactersListViewController: UINavigationControllerDelegate {

  func navigationController(_ navigationController: UINavigationController,
                            interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
    -> UIViewControllerInteractiveTransitioning? {
      guard let interactor = customInteractor else { return nil }
      return interactor.transitionInProgress ? customInteractor : nil
  }

  func navigationController(_ navigationController: UINavigationController,
                            animationControllerFor operation: UINavigationController.Operation,
                            from fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    guard let frame = selectedFrame, let image = selectedImage else { return nil }
    switch operation {
    case .push where fromVC is CharactersListViewController:
      customInteractor = TransitionInteractor(attachTo: toVC)
      return TransitionAnimator(duration: TimeInterval(UINavigationController.hideShowBarDuration),
                                isPresenting: true,
                                originFrame: frame,
                                image: image)
    case .pop where toVC is CharactersListViewController:
      return TransitionAnimator(duration: TimeInterval(UINavigationController.hideShowBarDuration),
                                isPresenting: false,
                                originFrame: frame,
                                image: image)
    default:
      return nil
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

    if let error = model.error {
      show(error: error)
    }
  }

  private func show(error: String) {
    let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      mainStore.dispatch(SearchCharactersFlow.didHandleAction())
    }))
    present(alert, animated: true, completion: nil)
  }

}
