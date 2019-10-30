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

    @discardableResult
    static func showWave(with param: TapAnimationParam,
                         completion: ((Bool) -> Void)?) -> String {
        let name = AniamtionHelper.key(param.layer.description)
          var animator = animations[name] as? TapAnimator
          if animator == nil {
              animator = TapAnimator(param)
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
    
    convenience init(_ param: TapAnimationParam) {
        self.init()
        self.layer = param.layer
        dot.bounds = CGRect(x: 0, y: 0, width: param.dotRadius * 2, height: param.dotRadius * 2)
        dot.position = CGPoint(x: 10000, y: 10000)
        dot.borderColor = UIColor.white.cgColor
        dot.cornerRadius = param.dotRadius
        dot.backgroundColor = param.color.cgColor
        layer.addSublayer(dot)
    }
    
    private override init() {
        super.init()
        self.layer = CALayer()
    }
    
    
    fileprivate  func showWave(_ param: TapAnimationParam,
                               completion: ((Bool) -> Void)?) {
        
        let position = CABasicAnimation(keyPath: "position")
        position.duration = 1
        position.timingFunction = CAMediaTimingFunction(name: .linear)
        position.fromValue = param.fromPoint
        position.toValue = param.endPoint
        position.fillMode = .forwards
        position.isRemovedOnCompletion = false
        dot.add(position, forKey: nil)
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.duration = 0.25
        scale.beginTime = CACurrentMediaTime() + 1 + 0.5
        scale.timingFunction = CAMediaTimingFunction(name: .easeOut)
        scale.fromValue = 1
        scale.fillMode = .forwards
        scale.isRemovedOnCompletion = false
        scale.toValue = 0.8
        dot.add(scale, forKey: nil)
        
        delay(seconds: 1.75, completion: {[weak self] in
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
    
    fileprivate func showWave(_ param: TapAnimationParam) {
       let endIndex: Int = param.waveCount
       for index in 0 ... endIndex {
           let cycle = CAShapeLayer()
           cycle.borderWidth = 1
           let cornerRadius: CGFloat = param.waveRadius
           cycle.borderColor = UIColor.clear.cgColor
           cycle.cornerRadius = cornerRadius
           cycle.frame = CGRect(x: layer.bounds.width * 0.5 - param.dotRadius,
                                y: layer.bounds.height * 0.5 - param.dotRadius,
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
        let duration: Double = Double(param.waveCount) * param.speed
           group.fillMode = .backwards
           group.setValue("wave", forKey: "name")
           group.beginTime = CACurrentMediaTime() + (Double(index) * duration) / Double(endIndex + 1)
           group.duration = duration
           group.repeatCount = param.repeateCount
           group.timingFunction = CAMediaTimingFunction(name: .default)
           group.animations = [scaleAnimation, borderAnimation, borderWidthAnimation]
           group.isRemovedOnCompletion = true
           group.delegate = self
           cycle.add(group, forKey: nil)
           layer.addSublayer(cycle)
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

