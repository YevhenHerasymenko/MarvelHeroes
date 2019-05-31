//
//  CharacterDescriptionTableViewCell.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import UIKit

class CharacterDescriptionTableViewCell: UITableViewCell, ReusableView {

  static var identifier: String = String(describing: CharacterDescriptionTableViewCell.self)

  @IBOutlet private weak var descriptionLabel: UILabel!

  struct Model: Equatable {
    let description: String?

    static var initial = Model(description: nil)
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
    descriptionLabel.text = model.description
  }

}
