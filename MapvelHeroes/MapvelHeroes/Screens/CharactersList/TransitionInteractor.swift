//
//  TransitionInteractor.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import UIKit

class TransitionInteractor: UIPercentDrivenInteractiveTransition {

  var navigationController: UINavigationController
  var shouldCompleteTransition = false
  var transitionInProgress = false

  init?(attachTo viewController: UIViewController) {
    if let navigationController = viewController.navigationController {
      self.navigationController = navigationController
      super.init()
      setupBackGesture(view: viewController.view)
    } else {
      return nil
    }
  }

  private func setupBackGesture(view: UIView) {
    let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
    swipeBackGesture.edges = .left
    view.addGestureRecognizer(swipeBackGesture)
  }

  @objc private func handleBackGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
    let viewTranslation = gesture.translation(in: gesture.view?.superview)
    let progress = viewTranslation.x / self.navigationController.view.frame.width

    switch gesture.state {
    case .began:
      transitionInProgress = true
      navigationController.popViewController(animated: true)
    case .changed:
      shouldCompleteTransition = progress > 0.5
      update(progress)
    case .cancelled:
      transitionInProgress = false
      cancel()
    case .ended:
      transitionInProgress = false
      shouldCompleteTransition ? finish() : cancel()
    default:
      return
    }
  }

}
