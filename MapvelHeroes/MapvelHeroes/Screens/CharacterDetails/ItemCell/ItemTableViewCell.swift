//
//  ItemTableViewCell.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell, ReusableView {

  static var identifier: String = String(describing: ItemTableViewCell.self)

  @IBOutlet private weak var nameLabel: UILabel!

  struct Model: Equatable {
    let name: String?

    static var initial = Model(name: nil)
  }

  var model = Model.initial {
    didSet {
      render()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  private func render() {
    nameLabel.text = model.name
  }

}
