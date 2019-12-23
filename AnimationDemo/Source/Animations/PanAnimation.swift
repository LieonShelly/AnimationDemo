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
    static func showPath(with param: PanParam, completion: ((Bool) -> Void)?) -> String {
        let name = AniamtionHelper.key(param.layer.description)
        var animator = animations[name] as? PanAnimatior
        if animator == nil {
            animator = PanAnimatior(param)
        }
        animator!.showAnimation(param) { (flag) in
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
   fileprivate lazy var dot: FXTutorialDot = {
          let dot = FXTutorialDot()
          return dot
      }()
    var layer: CALayer!
    var animationCompletion: ((Bool) -> Void)?

    convenience init(_ param: PanParam) {
        self.init()
        self.layer = param.layer
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
    
    fileprivate func showAnimation(_ param: PanParam, completion: ((Bool) -> Void)?) {
        guard let firstPoint = param.points.first else {
            return
        }
        dot.position = firstPoint
        self.animationCompletion = completion
        show(param)
        move(param)
        let duration = Float(param.points.count) / Float(param.speed)
        delay(seconds: Double(duration) + 0.3) {
            self.dismiss(CACurrentMediaTime(), param)
        }
    }
    
    private func move(_ param: PanParam) {
        let position = CAKeyframeAnimation(keyPath: "position")
        position.fillMode = .forwards
        position.beginTime = CACurrentMediaTime() + 0.3
        position.values = param.points
        position.calculationMode = .linear
        let duration = Float(param.points.count) / Float(param.speed) // 50 个点一秒
        position.duration = CFTimeInterval(duration)
        position.isRemovedOnCompletion = false
        dot.add(position, forKey: nil)
    }
    
    private func show(_ param: PanParam) {
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [0, 1.5, 1]
        scale.duration = 0.3
        scale.calculationMode = .linear
        scale.timingFunction = CAMediaTimingFunction(name: .easeOut)
        scale.fillMode = .backwards
        scale.isRemovedOnCompletion = false
        dot.add(scale, forKey: nil)
    }
    
    private func dismiss(_ beginTime: CFTimeInterval, _ param: PanParam) {

        let dismissGroup = CAAnimationGroup()
        dismissGroup.fillMode = .forwards
        dismissGroup.duration = 0.25
        dismissGroup.repeatCount = 1
        dismissGroup.repeatDuration = 1
        dismissGroup.isRemovedOnCompletion = false
        dismissGroup.delegate = self

        let dismissScale = CABasicAnimation(keyPath: "transform.scale")
        dismissScale.fromValue = 0.8
        dismissScale.toValue = 1.5

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0

        dismissGroup.beginTime = beginTime
        dismissGroup.animations = [
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


