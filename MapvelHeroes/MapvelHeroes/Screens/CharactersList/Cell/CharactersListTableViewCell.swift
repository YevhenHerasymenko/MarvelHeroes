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

  struct Model: Equatable {
    static var initial = Model()
  }

  var model = Model.initial {
    didSet {
      render()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  private func render() {}
    
}
