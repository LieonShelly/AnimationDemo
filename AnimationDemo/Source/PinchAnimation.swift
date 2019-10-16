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
    static func showKeyFrameDots(in layer: CALayer,
                                pointsA: [CGPoint],
                                pointsB: [CGPoint],
                                completion: ((Bool) -> Void)?) -> String {
        let name = AniamtionHelper.key(layer.description)
        var animator = animations[name] as? PinchAnimator
        if animator == nil {
            animator = PinchAnimator(layer)
            animations[name] = animator
        }
        animator!.showKeyFrameDot(pointsA, pointsB: pointsB, completion: { flag in
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
    fileprivate lazy var dot1: CALayer = {
        let dot1 = CALayer()
        dot1.contents = UIImage(named: "circle_gray")?.cgImage
        return dot1
    }()
    fileprivate lazy var dot2: CALayer = {
        let dot1 = CALayer()
        dot1.contents = UIImage(named: "circle_gray")?.cgImage
        return dot1
     }()
    
    private let dotCount: Int = 2
    private var aniamtionFinishDotCount: Int = 0
    
    
    convenience init(_ layer: CALayer) {
        self.init()
        self.layer = layer
        dot2.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        dot1.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        layer.addSublayer(dot1)
        layer.addSublayer(dot2)
    }
    
    private override init() {
        super.init()
        self.layer = CALayer()
    }
    
    
    fileprivate  func showKeyFrameDot(_ pointsA: [CGPoint], pointsB: [CGPoint], completion: ((Bool) -> Void)?) {
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.values = pointsA
        let pointCount = max(pointsA.count, pointsB.count)
        let duration = Float(pointCount) / 50 // 50 个点一秒
        positionAnimation.duration = CFTimeInterval(duration)
        positionAnimation.delegate = self

        dot1.add(positionAnimation, forKey: nil)
        positionAnimation.values = pointsB
        dot2.add(positionAnimation, forKey: nil)
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

class AniamtionHelper {
     static func key(_ str: String) -> String {
        return "IFAnimation" + str + "\(Date().timeIntervalSince1970)"
      }
}
