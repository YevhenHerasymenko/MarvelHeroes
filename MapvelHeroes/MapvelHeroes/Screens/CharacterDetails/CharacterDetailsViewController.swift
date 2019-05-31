//
//  CharacterDetailsViewController.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import UIKit
import MarvelHeroesCore

class CharacterDetailsViewController: UITableViewController {

  private enum Segue: String {
    case showItem
  }

  private enum Section: Int {
    case description
    case comics
    case stories
    case series
    case events
  }

  struct Model: ViewModel, Equatable {
    let name: String?
    let avatar: String?
    let description: String?
    let comics: [ItemTableViewCell.Model]
    let events: [ItemTableViewCell.Model]
    let stories: [ItemTableViewCell.Model]
    let series: [ItemTableViewCell.Model]

    static var initial: CharacterDetailsViewController.Model {
      return Model(name: nil, avatar: nil, description: nil, comics: [], events: [], stories: [], series: [])
    }
  }

  private static let titles = [nil, "comics", "stories", "series", "events"]

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
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mainStore.subscribe(self) { $0.select(CharacterDetailsDataTransformer.transform) }
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    mainStore.unsubscribe(self)
  }

  private func setupView() {
    tableView.tableHeaderView = UIView()
    tableView.tableFooterView = UIView()
    tableView.register(ItemTableViewCell.nib,
                       forCellReuseIdentifier: ItemTableViewCell.identifier)
    tableView.register(DescriptionTableViewCell.nib,
                       forCellReuseIdentifier: DescriptionTableViewCell.identifier)
  }

  deinit {
    mainStore.dispatch(CharacterDetailsFlow.clearCharacterInfo())
  }

}

// MARK: - IBActions
extension CharacterDetailsViewController {}

// MARK: - TableView
extension CharacterDetailsViewController {

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 5
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = Section(rawValue: section) else {
      return 0
    }
    switch section {
    case .description:
      return 1
    case .comics:
      return model.comics.count
    case .stories:
      return model.stories.count
    case .series:
      return model.series.count
    case .events:
      return model.events.count
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Section(rawValue: indexPath.section) else {
      fatalError()
    }
    let cell: UITableViewCell
    switch section {
    case .description:
      cell = descriptionCell(for: indexPath)
    case .comics:
      cell = comicsCell(for: indexPath)
    case .stories:
      cell = storiesCell(for: indexPath)
    case .series:
      cell = seriesCell(for: indexPath)
    case .events:
      cell = eventCell(for: indexPath)
    }
    return cell
  }

  private func descriptionCell(for indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.identifier,
                                                   for: indexPath) as? DescriptionTableViewCell else {
                                                    fatalError()
    }
    cell.model = DescriptionTableViewCell.Model(description: model.description)
    return cell
  }

  private func comicsCell(for indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier,
                                                   for: indexPath) as? ItemTableViewCell else {
                                                    fatalError()
    }
    cell.model = model.comics[indexPath.row]
    return cell
  }

  private func storiesCell(for indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier,
                                                   for: indexPath) as? ItemTableViewCell else {
                                                    fatalError()
    }
    cell.model = model.stories[indexPath.row]
    return cell
  }

  private func seriesCell(for indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier,
                                                   for: indexPath) as? ItemTableViewCell else {
                                                    fatalError()
    }
    cell.model = model.series[indexPath.row]
    return cell
  }

  private func eventCell(for indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier,
                                                   for: indexPath) as? ItemTableViewCell else {
                                                    fatalError()
    }
    cell.model = model.events[indexPath.row]
    return cell
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return CharacterDetailsViewController.titles[section]
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let section = Section(rawValue: indexPath.section) else {
      return
    }
    switch section {
    case .description:
      return
    case .comics:
      mainStore.dispatch(CharacterDetailsFlow.didSelectComics(at: indexPath.row))
    case .stories:
      mainStore.dispatch(CharacterDetailsFlow.didSelectStory(at: indexPath.row))
    case .series:
      mainStore.dispatch(CharacterDetailsFlow.didSelectSerie(at: indexPath.row))
    case .events:
      mainStore.dispatch(CharacterDetailsFlow.didSelectEvent(at: indexPath.row))
    }
    performSegue(withIdentifier: Segue.showItem.rawValue, sender: nil)
  }

}

// MARK: - StoreSubscriber
extension CharacterDetailsViewController: StoreSubscriber {
  func newState(state: Model) {
    model = state
  }
}

// MARK: - Model Support
extension CharacterDetailsViewController: ViewControllerModelSupport {

  func render(_ model: Model) {
    tableView.reloadData()

    title = model.name
  }

}
