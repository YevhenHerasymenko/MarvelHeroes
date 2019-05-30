//
//  CharactersListTableViewCell.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/30/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import UIKit

class CharactersListTableViewCell: UITableViewCell, ReusableView {

  static var identifier: String = String(describing: CharactersListTableViewCell.self)

  @IBOutlet private weak var avatarView: UIImageView!
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var saveButton: UIButton!

  struct Model: Equatable {
    let avatarURL: String?
    let name: String?
    let isSaved: Bool
    let saveAction: (() -> Void)?

    static func == (lhs: Model, rhs: Model) -> Bool {
      return lhs.avatarURL == rhs.avatarURL && lhs.name == rhs.name && lhs.isSaved == rhs.isSaved
    }

    static var initial = Model(avatarURL: nil, name: nil, isSaved: false, saveAction: nil)
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
    avatarView.imageFromServerURL(model.avatarURL, placeHolder: nil)
    nameLabel.text = model.name

    let text = NSLocalizedString(model.isSaved ? "delete" : "save", comment: "")
    saveButton.setTitle(text, for: .normal)
  }

  @IBAction func didTapButton() {
    model.saveAction?()
  }
    
}
