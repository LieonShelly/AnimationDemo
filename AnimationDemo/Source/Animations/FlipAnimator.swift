//
//  FlipAnimator.swift
//  LogoReveal
//
//  Created by lieon on 2019/10/16.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//  翻转动画

import UIKit

class FlipAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var operation: UINavigationController.Operation = .push
    var duration: Double = 1.0
    var direction: FlipDirection = .leftToRight
    enum FlipDirection {
        case leftToRight
        case rightToLeft
        var options: UIView.AnimationOptions {
            switch self {
            case .leftToRight:
                return .transitionFlipFromLeft
            case .rightToLeft:
                return .transitionFlipFromRight
            }
        }
        
        var reverseDirection: FlipDirection {
            switch self {
            case .leftToRight:
                return .rightToLeft
            case .rightToLeft:
                return .leftToRight
            }
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    weak var transitionContext: UIViewControllerContextTransitioning?
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
     
        self.transitionContext = transitionContext
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: .to)!
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toView = toViewController.view!
        let fromView = fromViewController.view!
        let reverse: Bool = operation == .push ? false: true
        let direction: CGFloat = reverse ? 1 : -1
        let const: CGFloat = -1.0 / 1000

        toView.layer.anchorPoint = CGPoint(x: direction == 1 ? 0 : 1, y: 0.5)
        fromView.layer.anchorPoint = CGPoint(x: direction == 1 ? 1 : 0, y: 0.5)

        var viewFromTransform: CATransform3D = CATransform3DMakeRotation(direction * CGFloat.pi * 0.5, 0.0, 1.0, 0.0)
        var viewToTransform: CATransform3D = CATransform3DMakeRotation(-direction * CGFloat.pi * 0.5, 0.0, 1.0, 0.0)
        viewFromTransform.m34 = const
        viewToTransform.m34 = const

        containerView.transform = CGAffineTransform(translationX: direction * containerView.frame.size.width / 2.0, y: 0)
        toView.layer.transform = viewToTransform
        containerView.addSubview(toView)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                  animations: {
                   containerView.transform = CGAffineTransform(translationX: -direction * containerView.frame.size.width / 2.0, y: 0)
                                 fromView.layer.transform = viewFromTransform
                                 toView.layer.transform = CATransform3DIdentity
        }) { (_) in
            containerView.transform = CGAffineTransform.identity
            fromView.layer.transform = CATransform3DIdentity
            toView.layer.transform = CATransform3DIdentity
            fromView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

            if (transitionContext.transitionWasCancelled) {
                toView.removeFromSuperview()
            } else {
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    
    deinit {
        debugPrint("deinit - FlipAnimator")
    }
    
    func setMenu(toPercent percent: CGFloat, fromView: UIView, toView: UIView) {
        fromView.frame.origin.x = -UIScreen.main.bounds.width  * CGFloat(percent)
        toView.layer.transform = menuTransform(percent: percent)
      }

      func menuTransform(percent: CGFloat) -> CATransform3D {
        var identity = CATransform3DIdentity
        identity.m34 = -1.0/1000

        let remainingPercent = 1.0 - percent
        let angle = remainingPercent * .pi * -0.5

        let rotationTransform = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0)

        let translationTransform = CATransform3DMakeTranslation(UIScreen.main.bounds.width * percent, 0, 0)
        return CATransform3DConcat(rotationTransform, translationTransform)
      }
}


extension FlipAnimator: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        transitionContext?.completeTransition(true)
    }
}
