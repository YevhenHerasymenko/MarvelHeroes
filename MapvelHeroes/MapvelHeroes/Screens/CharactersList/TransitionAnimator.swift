//
//  TransitionAnimator.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/31/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  var duration: TimeInterval
  var isPresenting: Bool
  var originFrame: CGRect
  var image: UIImage

  init(duration: TimeInterval, isPresenting: Bool, originFrame: CGRect, image: UIImage) {
    self.duration = duration
    self.isPresenting = isPresenting
    self.originFrame = originFrame
    self.image = image
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let container = transitionContext.containerView

    guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
      let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
      let toView = toViewController.view,
      let fromView = fromViewController.view else {
        return
    }

    self.isPresenting
      ? container.addSubview(toViewController.view)
      : container.insertSubview(toViewController.view, belowSubview: fromViewController.view)

    let detailVC = (isPresenting ? toViewController : fromViewController) as? CharacterDetailsViewController
    guard let detailController = detailVC,
      let header = detailController.imageView,
      let detailView = detailController.view else {
      return
    }
    header.image = image
    header.alpha = 0

    let headerFrame = detailController.tableView.convert(header.frame, to: nil)

    let transitionImageView = UIImageView(frame: isPresenting ? originFrame : headerFrame)
    transitionImageView.image = image
    transitionImageView.contentMode = .scaleAspectFit

    container.addSubview(transitionImageView)

    toView.frame = isPresenting
      ?  CGRect(x: fromView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
      : toView.frame
    toView.alpha = isPresenting ? 0 : 1
    toView.layoutIfNeeded()

    UIView.animate(withDuration: duration, animations: {
      transitionImageView.frame = self.isPresenting ? header.frame : self.originFrame
      detailView.frame = self.isPresenting
        ? fromView.frame
        : CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
      detailView.alpha = self.isPresenting ? 1 : 0
    }, completion: { _ in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      transitionImageView.removeFromSuperview()
      header.alpha = 1
    })
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
}
