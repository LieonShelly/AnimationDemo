//
//  PanAnimation.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

class PanAnimation {
    static var animations: [String: Any?] = [:]
    
    @discardableResult
    static func showPath( in layer: CALayer, points: [CGPoint], completion: ((Bool) -> Void)?) -> String {
        let name = AniamtionHelper.key(layer.description)
        var animator = animations[name] as? PanAnimatior
        if animator == nil {
            animator = PanAnimatior(layer)
        }
        animator!.showAnimation(points) { (flag) in
            animator!.clear()
            clear(name)
            completion?(flag)
        }
        animations[name] = animator
        return name
    }
    
    static func clear(_ name: String) {
        animations[name] = nil
    }
}

class PanAnimatior: NSObject, AnimationTargetType {
   fileprivate lazy var dot: CAShapeLayer = {
          let dot = CAShapeLayer()
          dot.backgroundColor = UIColor.gray.cgColor
          return dot
      }()
    var layer: CALayer!
    var animationCompletion: ((Bool) -> Void)?

    convenience init(_ layer: CALayer) {
        self.init()
        self.layer = layer
        dot.cornerRadius = 20
        dot.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        dot.borderColor = UIColor.white.cgColor
        dot.borderWidth = 3
        layer.addSublayer(dot)
    }
    
    private override init() {
        super.init()
        self.layer = CALayer()
    }
    
    fileprivate func showAnimation(_ points: [CGPoint], completion: ((Bool) -> Void)?) {
        guard let firstPoint = points.first else {
            return
        }
        dot.position = firstPoint
        self.animationCompletion = completion
        show()

        let position = CAKeyframeAnimation(keyPath: "position")
        position.fillMode = .forwards
        position.beginTime = CACurrentMediaTime() + 0.5 + 0.25
        position.values = points
        position.calculationMode = .linear
        let duration = Float(points.count) / 50.0 // 50 个点一秒
        position.duration = CFTimeInterval(duration)
        position.isRemovedOnCompletion = false
        dot.add(position, forKey: nil)

        delay(seconds: Double(duration) + 0.5 + 0.25) {
            self.dismiss(CACurrentMediaTime())
        }
    }
    
    private func show() {
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
        showScaleAnimation.toValue = 1.5
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0
        opacity.toValue = 1
        showGroup.animations = [showScaleAnimation, opacity]
        dot.add(showScaleAnimation, forKey: nil)

        let group = CAAnimationGroup()
        group.fillMode = .forwards
        group.beginTime = CACurrentMediaTime() + 0.5
        group.duration = 0.25
        group.repeatCount = 1
        group.repeatDuration = 1
        group.isRemovedOnCompletion = false

        let showScaleAnimation0 = CABasicAnimation(keyPath: "transform.scale")
        showScaleAnimation0.fromValue = 1.5
        showScaleAnimation.toValue = 1

        let borderColorAnima = CABasicAnimation(keyPath: "borderColor")
        borderColorAnima.fromValue = dot.borderColor
        borderColorAnima.toValue = UIColor.white.cgColor

        let bgColorAnima = CABasicAnimation(keyPath: "backgroundColor")
        bgColorAnima.fromValue = dot.backgroundColor
        bgColorAnima.toValue = UIColor.white.cgColor
        bgColorAnima.isRemovedOnCompletion = false

        group.animations = [showScaleAnimation0, borderColorAnima, bgColorAnima]
        group.timingFunction = CAMediaTimingFunction(name: .easeIn)
        dot.add(group, forKey: nil)
    }
    
    private func dismiss(_ beginTime: CFTimeInterval) {
        let dismissGroup = CAAnimationGroup()
        dismissGroup.fillMode = .forwards
        dismissGroup.duration = 0.25
        dismissGroup.repeatCount = 1
        dismissGroup.repeatDuration = 1
        dismissGroup.isRemovedOnCompletion = false
        dismissGroup.delegate = self

        let dismissBgColorAnima = CABasicAnimation(keyPath: "backgroundColor")
        dismissBgColorAnima.toValue = UIColor.white.cgColor
        dismissBgColorAnima.toValue = UIColor.gray

        let borderWidth = CABasicAnimation(keyPath: "borderWidth")
        borderWidth.fromValue = 0
        borderWidth.toValue = 2

        let dismissScale = CABasicAnimation(keyPath: "transform.scale")
        dismissScale.fromValue = 1
        dismissScale.toValue = 2

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0

        dismissGroup.beginTime = beginTime
        dismissGroup.animations = [
                 dismissBgColorAnima,
                 borderWidth,
                 dismissScale,
                 opacity]
        self.dot.add(dismissGroup, forKey: nil)
    }
    
    internal func clear() {
        dot.removeAllAnimations()
        dot.removeFromSuperlayer()
    }
    
    deinit {
        debugPrint("deinit - PanAnimatior")
    }
    
}

extension PanAnimatior: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationCompletion?(flag)
    }
}

