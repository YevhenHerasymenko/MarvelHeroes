//
//  ItemDetailsViewController.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import UIKit
import MarvelHeroesCore

class ItemDetailsViewController: UITableViewController {

  private enum Row: Int {
    case image
    case text
  }

  struct Model: ViewModel, Equatable {
    let title: String?
    let imageUrl: String?
    let description: String?

    static var initial: ItemDetailsViewController.Model {
      return Model(title: nil, imageUrl: nil, description: nil)
    }
  }

  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var descriptionLabel: UILabel!

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
    mainStore.subscribe(self) { $0.select(ItemDetailsDataTransformer.transform) }
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    mainStore.unsubscribe(self)
  }

  private func setupView() {
    tableView.tableHeaderView = UIView()
    tableView.tableFooterView = UIView()
  }

  deinit {
    mainStore.dispatch(CharacterDetailsFlow.clearItemInfo())
  }

}

// MARK: - IBActions
extension ItemDetailsViewController {}

// MARK: - TableView
extension ItemDetailsViewController {

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let row = Row(rawValue: indexPath.row) else {
      return 0
    }
    switch row {
    case .image:
      return model.imageUrl == nil ? 0 : UITableView.automaticDimension
    case .text:
      return model.title == nil ? 0 : UITableView.automaticDimension
    }
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.description != nil || model.imageUrl != nil ? 2 : 0
  }

}

// MARK: - StoreSubscriber
extension ItemDetailsViewController: StoreSubscriber {
  func newState(state: Model) {
    model = state
  }
}

// MARK: - Model Support
extension ItemDetailsViewController: ViewControllerModelSupport {

  func render(_ model: Model) {
    title = model.title
    imageView.imageFromServerURL(model.imageUrl, placeHolder: nil)
    descriptionLabel.text = model.description

    tableView.reloadData()
  }

}
