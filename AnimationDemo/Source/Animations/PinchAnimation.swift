//
//  PinchAnimation.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/9.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit


class PinchAnimation {
    static var animations: [String: Any] = [:]
    
    @discardableResult
    static func showKeyFrameDots(with param: PinchParam,
                                completion: ((Bool) -> Void)?) -> String {
        let name = AniamtionHelper.key(param.layer.description)
        var animator = animations[name] as? PinchAnimator
        if animator == nil {
            animator = PinchAnimator(param)
            animations[name] = animator
        }
        animator!.showKeyFrameDot(param, completion: { flag in
            clear(name)
            completion?(flag)
        })
        return name
    }
    
    
    static func clear(_ animationKey: String?) {
        guard let animationKey = animationKey,
            let helper = animations[animationKey] as? PinchAnimator else {
            return
        }
        helper.clear()
        animations[animationKey] = nil
    }
    
  
}


class PinchAnimator: NSObject, AnimationTargetType {
    var layer: CALayer!
    var animationCompletion: ((Bool) -> Void)?
    fileprivate lazy var dot1: CAShapeLayer = {
        let dot = CAShapeLayer()
        return dot
    }()
    fileprivate lazy var dot2: CAShapeLayer = {
        let dot = CAShapeLayer()
        return dot
    }()
    
    private let dotCount: Int = 2
    private var aniamtionFinishDotCount: Int = 0
    
    
    convenience init(_ param: PinchParam) {
        self.init()
        self.layer = param.layer
        config(dot1, param: param)
        config(dot2, param: param)
    }
    
    private func config(_ dot: CAShapeLayer, param: PinchParam) {
        dot.cornerRadius = param.dotRadius
        dot.backgroundColor = param.dotStartFillColor.cgColor
        dot.bounds = CGRect(x: 0, y: 0, width: param.dotRadius * 2, height: param.dotRadius * 2)
        dot.opacity = 1
        dot.borderColor = param.dotStartBorderColor.cgColor
        dot.borderWidth = param.dotBorderWidth
        layer.addSublayer(dot)
    }
    
    private override init() {
        super.init()
        self.layer = CALayer()
    }
    
    
    fileprivate  func showKeyFrameDot(_ param: PinchParam, completion: ((Bool) -> Void)?) {
        guard let firstPointA = param.pointsA.first, let firstPointB = param.pointsB.first else {
            return
        }
        dot1.position = firstPointA
        dot2.position = firstPointB
        show(param, dot: dot1)
        show(param, dot: dot2)
        move(param)
        let pointCount = max(param.pointsA.count, param.pointsB.count)
        let duration = Float(pointCount) / Float(param.speed)
        dismiss(CACurrentMediaTime() +  Double(duration) + 0.5 + 0.5, param)
        self.animationCompletion = completion
    }
    
    
    internal func clear() {
        dot1.removeAllAnimations()
        dot2.removeAllAnimations()
        dot1.removeFromSuperlayer()
        dot2.removeFromSuperlayer()
    }
    
    deinit {
        debugPrint("deinit - PinchHelper")
    }
    
}

extension PinchAnimator: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        aniamtionFinishDotCount += 1
        if aniamtionFinishDotCount == dotCount {
            aniamtionFinishDotCount = 0
            animationCompletion?(flag)
        }
    }
}

extension PinchAnimator {
    
    fileprivate func show(_ param: PinchParam, dot: CALayer) {
       let showGroup = CAAnimationGroup()
       showGroup.fillMode = .forwards
       showGroup.beginTime = CACurrentMediaTime()
       showGroup.duration = 0.25
       showGroup.repeatCount = 1
       showGroup.repeatDuration = 1
       showGroup.isRemovedOnCompletion = false
       showGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
       
       let showScaleAnimation = CABasicAnimation(keyPath: "transform.scale")
       showScaleAnimation.fromValue = 0
       showScaleAnimation.toValue = 1
       
       let opacity = CABasicAnimation(keyPath: "opacity")
       opacity.fromValue = 0
       opacity.toValue = 1
       
       
       showGroup.animations = [showScaleAnimation, opacity]
       dot.add(showGroup, forKey: nil)
       

       let group = CAAnimationGroup()
       group.fillMode = .forwards
       group.beginTime = CACurrentMediaTime() + 0.25 + 0.5
       group.duration = 0.25
       group.repeatCount = 1
       group.repeatDuration = 1
       group.isRemovedOnCompletion = false

       let showScaleAnimation0 = CABasicAnimation(keyPath: "transform.scale")
       showScaleAnimation0.fromValue = 1
       showScaleAnimation0.toValue = 0.8

       let borderColorAnima = CABasicAnimation(keyPath: "borderColor")
       borderColorAnima.fromValue = dot.borderColor
       borderColorAnima.toValue = param.dotMoveColor.cgColor

       
       let bgColorAnima = CABasicAnimation(keyPath: "backgroundColor")
       bgColorAnima.fromValue = dot.backgroundColor
       bgColorAnima.toValue = param.dotMoveColor.cgColor
       
       group.animations = [showScaleAnimation0, borderColorAnima, bgColorAnima]
       group.timingFunction = CAMediaTimingFunction(name: .easeIn)
       dot.add(group, forKey: nil)
   }
    
    fileprivate func move(_ param: PinchParam) {
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.fillMode = .forwards
        positionAnimation.isRemovedOnCompletion = false
        positionAnimation.beginTime = CACurrentMediaTime() + 0.25 + 0.5 + 0.25
        positionAnimation.values = param.pointsA
        let pointCount = max(param.pointsA.count, param.pointsB.count)
        let duration = Float(pointCount) / Float(param.speed)
        positionAnimation.duration = CFTimeInterval(duration)

        dot1.add(positionAnimation, forKey: nil)
        positionAnimation.values = param.pointsB
        dot2.add(positionAnimation, forKey: nil)

    }
    
    
    private func dismiss(_ beginTime: CFTimeInterval, _ param: PinchParam) {
        let dismissGroup = CAAnimationGroup()
        dismissGroup.fillMode = .forwards
        dismissGroup.duration = 0.25
        dismissGroup.repeatCount = 1
        dismissGroup.repeatDuration = 1
        dismissGroup.isRemovedOnCompletion = false
        dismissGroup.delegate = self

        let dismissBgColorAnima = CABasicAnimation(keyPath: "backgroundColor")
        dismissBgColorAnima.toValue = param.dotEndFillColor.cgColor

        let borderWidth = CABasicAnimation(keyPath: "borderWidth")
        borderWidth.fromValue = 0
        borderWidth.toValue = param.dotBorderWidth

        let dismissScale = CABasicAnimation(keyPath: "transform.scale")
        dismissScale.fromValue = 0.8
        dismissScale.toValue = 1.5

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0

        dismissGroup.beginTime = beginTime
        dismissGroup.animations = [
                 dismissBgColorAnima,
                 borderWidth,
                 dismissScale,
                 opacity]
        dot1.add(dismissGroup, forKey: nil)
        dot2.add(dismissGroup, forKey: nil)
    }
    
       
}

class AniamtionHelper {
     static func key(_ str: String) -> String {
        return "IFAnimation" + str + "\(Date().timeIntervalSince1970)"
      }
}


