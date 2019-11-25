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
    fileprivate lazy var dot: FXTutorialDot = {
        let dot1 = FXTutorialDot()
        return dot1
    }()
    
    fileprivate lazy var outterDot: CALayer = {
        let dot1 = CALayer()
        return dot1
    }()
    var outterFrame: CGRect = .zero
    var innerFrame: CGRect = .zero
    
    
    convenience init(_ param: TapAnimationParam) {
        self.init()
        self.layer = param.layer
        self.outterFrame = CGRect(x: 0, y: 0, width: param.dotRadius * 2.5, height: param.dotRadius * 2.5)
        outterDot.bounds = outterFrame
        outterDot.position = param.endPoint! //CGPoint(x: 10000, y: 10000)
        outterDot.borderColor = UIColor.white.cgColor
        outterDot.borderWidth = 2
        outterDot.cornerRadius = outterFrame.width * 0.5
        outterDot.backgroundColor = UIColor.clear.cgColor
        outterDot.opacity = 0
        layer.addSublayer(outterDot)
        
        innerFrame =  CGRect(x: 0, y: 0, width: param.dotRadius * 2, height: param.dotRadius * 2)
        dot.bounds = innerFrame
        dot.position = param.endPoint! //CGPoint(x: 10000, y: 10000)
        dot.borderColor = UIColor.white.cgColor
        dot.cornerRadius  = param.dotRadius
        dot.backgroundColor = param.color.cgColor
        layer.addSublayer(dot)
        
        
    }
    
    private override init() {
        super.init()
        self.layer = CALayer()
    }
    
    
    fileprivate  func showWave(_ param: TapAnimationParam,
                               completion: ((Bool) -> Void)?) {
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [0, 1.5, 1]
        scale.duration = 0.3
        scale.calculationMode = .linear
        scale.timingFunction = CAMediaTimingFunction(name: .easeOut)
        scale.fillMode = .backwards
        scale.isRemovedOnCompletion = false
        dot.add(scale, forKey: nil)
        
        let group = CAAnimationGroup()
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false
        group.duration = 0.3
        group.beginTime = CACurrentMediaTime() + 0.2
        
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [0, 1, 0]
        opacity.calculationMode = .linear
        
        let newScale = CABasicAnimation(keyPath: "transform.scale")
        newScale.fromValue = 0
        newScale.toValue = 2
        group.delegate = self
        group.animations = [newScale, opacity]
        outterDot.add(group, forKey: nil)
        
        //        outterDot.opacity = 0
        
        let dismissGroup = CAAnimationGroup()
        dismissGroup.timingFunction = CAMediaTimingFunction(name: .linear)
        dismissGroup.fillMode = .forwards
        dismissGroup.isRemovedOnCompletion = false
        dismissGroup.beginTime = CACurrentMediaTime() + 0.2 + 0.15
        dismissGroup.duration = 0.3
        dismissGroup.delegate = self
        dismissGroup.setValue("dismissGroup", forKey: "name")
        
        let dismissOpacity = CABasicAnimation(keyPath: "opacity")
        dismissOpacity.fromValue = 1
        dismissOpacity.toValue = 0
        
        newScale.fromValue = 1
        newScale.toValue = 2
        dismissGroup.animations = [newScale, dismissOpacity]
        dot.add(dismissGroup, forKey: nil)
        self.animationCompletion = completion
        return
    }
    
    
    internal func clear() {
        dot.removeAllAnimations()
        dot.removeFromSuperlayer()
        outterDot.removeAllAnimations()
        outterDot.removeFromSuperlayer()
    }
    
    deinit {
        debugPrint("deinit - ITTapAnimator")
    }
    
}

extension TapAnimator: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let name = anim.value(forKey: "name") as? String, name == "dismissGroup" {
            animationCompletion?(flag)
            return
        }
        
        
    }
}



class FXTutorialDot: CALayer {
    struct UISize {
        static let inset: CGFloat = 2
    }
    fileprivate lazy var innerLayer:  CALayer = {
        let gradientLayer = CALayer()
        gradientLayer.backgroundColor = UIColor(hex: 0xC47AFF)?.cgColor
        return gradientLayer
    }()
    
    
    override func layoutSublayers() {
        super.layoutSublayers()
        borderWidth = UISize.inset
        borderColor = UIColor.white.cgColor
        let inserFrame = bounds.insetBy(dx: UISize.inset, dy: UISize.inset)
        innerLayer.frame = inserFrame
        innerLayer.cornerRadius = inserFrame.width * 0.5
        innerLayer.masksToBounds = true
    }
    
    override init() {
        super.init()
        addSublayer(innerLayer)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
