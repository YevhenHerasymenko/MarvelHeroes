//
//  PaginationTableViewCell.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import UIKit

class PaginationTableViewCell: UITableViewCell, ReusableView {

  static var identifier: String = String(describing: PaginationTableViewCell.self)

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

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

  private func render() {
    activityIndicator.startAnimating()
  }

}
