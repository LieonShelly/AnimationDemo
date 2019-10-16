//
//  TapAniamtion.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/9.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

class TapAniamtion {
    static var animations: [String: Any?] = [:]
    
    static func jumpSpring(with param: AnimationParam) {
        let jump = CASpringAnimation(keyPath: "position.y")
        jump.fromValue = param.layer.position.y + 1
        jump.toValue = param.layer.position.y
        jump.duration = jump.settlingDuration
        jump.initialVelocity = 100.0
        jump.mass = 10
        jump.stiffness = 15000
        jump.damping = 50
        param.layer.add(jump, forKey: nil)

    }
    
    @discardableResult
    static func showWave(with param: AnimationParam,
                         completion: ((Bool) -> Void)?) -> String {
        let name = AniamtionHelper.key(param.layer.description)
          var animator = animations[name] as? TapAnimator
          if animator == nil {
              animator = TapAnimator(param.layer)
              animations[name] = animator
          }
        animator?.showWave(param, completion: { (flag) in
            clear(name)
            completion?(flag)
        })
          return name
      }
    
    static func clear(_ animationKey: String?) {
         guard let animationKey = animationKey,
             let helper = animations[animationKey] as? TapAnimator else {
             return
         }
         helper.clear()
         animations[animationKey] = nil
     }
      
}

class TapAnimator: NSObject, AnimationTargetType {
    var layer: CALayer!
    var animationCompletion: ((Bool) -> Void)?
    fileprivate lazy var dot: CAShapeLayer = {
        let dot1 = CAShapeLayer()
        return dot1
    }()
    let radius: CGFloat = 10
    convenience init(_ layer: CALayer) {
        self.init()
        self.layer = layer
        dot.frame = layer.bounds
        dot.fillColor = UIColor.gray.cgColor
        dot.backgroundColor = UIColor.clear.cgColor
        layer.addSublayer(dot)
    }
    
    private override init() {
        super.init()
        self.layer = CALayer()
    }
    
    
    fileprivate  func showWave(_ param: AnimationParam,
                               completion: ((Bool) -> Void)?) {
        let center = layer.position
        let path = UIBezierPath(roundedRect: CGRect(x: center.x - radius,
                                               y: center.y - radius,
                                               width: radius * 2,
                                               height: radius * 2),
                           cornerRadius: radius)
        dot.path = path.cgPath
        let position = CABasicAnimation(keyPath: "position")
        position.duration = 1
        position.timingFunction = CAMediaTimingFunction(name: .linear)
        position.fromValue = param.fromPoint
        position.toValue = param.endPoint
        dot.add(position, forKey: nil)
        delay(seconds: 1, completion: {[weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.showWave(param)
        })
        self.animationCompletion = completion
    }
    
    
    internal func clear() {
        dot.removeAllAnimations()
        dot.removeFromSuperlayer()
    }
    
    fileprivate func showWave(_ param: AnimationParam) {
       let endIndex: Int = 0
       for index in 0 ... endIndex {
           let cycle = CAShapeLayer()
           cycle.borderWidth = 1
           let cornerRadius: CGFloat = 30
           cycle.borderColor = UIColor.clear.cgColor
           cycle.cornerRadius = cornerRadius
           cycle.frame = CGRect(x: layer.bounds.width * 0.5 - radius,
                                y: layer.bounds.height * 0.5 - radius,
                                width: cornerRadius * 2,
                                height: cornerRadius * 2)
           cycle.position = layer.position
           let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
           scaleAnimation.fromValue = 1
           scaleAnimation.toValue = 4
           
           let borderAnimation = CAKeyframeAnimation()
           borderAnimation.keyPath = "borderColor"
           borderAnimation.values = [param.color.withAlphaComponent(0.9).cgColor,
                                     param.color.withAlphaComponent(0.8).cgColor,
                                     param.color.withAlphaComponent(0.715).cgColor,
                                     param.color.withAlphaComponent(0.6).cgColor,
                                     param.color.withAlphaComponent(0.475).cgColor,
                                     param.color.withAlphaComponent(0.35).cgColor,
                                     param.color.withAlphaComponent(0.225).cgColor,
                                     param.color.withAlphaComponent(0.1).cgColor]
           
           let borderWidthAnimation = CAKeyframeAnimation()
           borderWidthAnimation.keyPath = "borderWidth"
           borderWidthAnimation.values = [10,
                                   8,
                                   4,
                                   2,
                                   1,
                                   0.8,
                                   0.5,
                                   0.1]
           let group = CAAnimationGroup()
          let duration: Double = param.duration
           group.fillMode = .backwards
           group.setValue("wave", forKey: "name")
           group.beginTime = CACurrentMediaTime() + (Double(index) * duration) / Double(endIndex + 1)
           group.duration = duration
           group.repeatCount = 1
           group.timingFunction = CAMediaTimingFunction(name: .default)
           group.animations = [scaleAnimation, borderAnimation, borderWidthAnimation]
           group.isRemovedOnCompletion = true
           group.delegate = self
           cycle.add(group, forKey: nil)
           dot.addSublayer(cycle)
       }
    }
    
    deinit {
        debugPrint("deinit - ITTapAnimator")
    }
    
}

extension TapAnimator: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
         animationCompletion?(flag)
    }
}

