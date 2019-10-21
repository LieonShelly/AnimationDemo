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
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
       guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        direction = operation == .push ? direction : direction.reverseDirection
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        transitionContext.containerView.addSubview(toVC.view)
       
        UIView.transition(from: fromVC.view,
                          to: toVC.view,
                          duration: duration,
                          options: direction.options) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
    deinit {
        debugPrint("deinit - FlipAnimator")
    }
}
