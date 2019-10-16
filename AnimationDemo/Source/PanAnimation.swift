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
   fileprivate lazy var dot1: CALayer = {
          let dot1 = CALayer()
          dot1.contents = UIImage(named: "circle_gray")?.cgImage
          return dot1
      }()
    var layer: CALayer!
    var animationCompletion: ((Bool) -> Void)?

    convenience init(_ layer: CALayer) {
        self.init()
        self.layer = layer
        dot1.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        layer.addSublayer(dot1)

    }
    
    private override init() {
        super.init()
        self.layer = CALayer()
    }
    
    fileprivate func showAnimation(_ points: [CGPoint], completion: ((Bool) -> Void)?) {
        let position = CAKeyframeAnimation(keyPath: "position")
       position.values = points
       position.calculationMode = .linear
       let duration = Float(points.count) / 50.0 // 50 个点一秒
       position.duration = CFTimeInterval(duration)
       dot1.add(position, forKey: nil)
    }
    
    internal func clear() {
        dot1.removeAllAnimations()
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

