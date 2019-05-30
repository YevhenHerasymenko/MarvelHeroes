//
//  ViewIdentifier.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/30/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import UIKit

protocol ViewIdentifier {
  static var identifier: String { get }
}

protocol ReusableView: ViewIdentifier {
  static var nib: UINib { get }
}

protocol ViewNib: ReusableView {
  associatedtype ViewType

  static var instanceFromNib: ViewType { get }
}

extension ReusableView {
  static var nib: UINib {
    return UINib(nibName: self.identifier, bundle: nil)
  }
}
