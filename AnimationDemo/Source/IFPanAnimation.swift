//
//  IFPanAnimation.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

class IFPanAnimation {
    static var animations: [String: Any?] = [:]
    
    @discardableResult
    static func showPath( in layer: CALayer, points: [CGPoint], completion: ((Bool) -> Void)?) -> String {
        let name = AniamtionHelper.key(layer.description)
        var animator = animations[name] as? PanAnimatior
        if animator == nil {
            animator = PanAnimatior(layer, points: points)
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
    var layer: CALayer!
    var animationCompletion: ((Bool) -> Void)?
    fileprivate lazy var pathLayer: CAShapeLayer = {
        let pathLayer = CAShapeLayer()
        return pathLayer
    }()
    
    convenience init(_ layer: CALayer, points: [CGPoint]) {
        self.init()
        self.layer = layer
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.yellow.cgColor
        pathLayer.lineWidth = 10
        pathLayer.lineJoin = .round
        pathLayer.lineCap = .round
        pathLayer.frame = layer.bounds
        layer.addSublayer(pathLayer)
    }
    
    private override init() {
        super.init()
        self.layer = CALayer()
    }
    
    fileprivate func showAnimation(_ points: [CGPoint], completion: ((Bool) -> Void)?) {
        let path = UIBezierPath()
        var points = points.map { $0 }
        guard let firstPoint = points.first else {
            return
        }
        path.move(to: firstPoint)
        points.removeFirst()
        points.forEach { path.addLine(to: $0)}
        path.stroke()
        path.close()
        self.animationCompletion = completion
        pathLayer.path = path.cgPath
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.duration = 2
        strokeEndAnimation.toValue = 1.0
        strokeEndAnimation.delegate = self
        pathLayer.add(strokeEndAnimation, forKey: nil)
    }
    
    internal func clear() {
        pathLayer.removeAllAnimations()
        pathLayer.removeFromSuperlayer()
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

