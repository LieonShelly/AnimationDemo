//
//  FXMoveAniamtion.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/13.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

class FXMoveAniamtion {
    static var animations: [String: Any?] = [:]

    @discardableResult
    static func showMove(with param: MoveAnimationParam,
                         completion: ((Bool) -> Void)?) -> String {
        let name = AniamtionHelper.key(param.containerView.description)
        var animator = animations[name] as? FXMoveAnimator
        if animator == nil {
          animator = FXMoveAnimator(param)
          animations[name] = animator
        }
        animator!.move(param)
        return name
    }
    
    static func clear(_ animationKey: String?) {
         guard let animationKey = animationKey,
             let helper = animations[animationKey] as? FXMoveAnimator else {
             return
         }
         helper.clear()
         animations[animationKey] = nil
     }
      
}

class FXMoveAnimator: NSObject {
    var containerView: UIView!
    var animationCompletion: ((Bool) -> Void)?
    fileprivate lazy var dot: UIView = {
        let dot = UIView()
        return dot
    }()
    
    convenience init(_ param: MoveAnimationParam) {
        self.init()
        self.containerView = param.containerView!
        dot.bounds = CGRect(x: 0, y: 0, width: param.dotRadius * 2, height: param.dotRadius * 2)
        dot.center = param.position!
        dot.layer.borderColor = UIColor.white.cgColor
        dot.layer.cornerRadius = param.dotRadius
        dot.backgroundColor = param.color
     
        dot.backgroundColor = .clear
        containerView.addSubview(dot)
        
        let dotLayer = FXTutorialDot()
        dotLayer.borderColor = UIColor.white.cgColor
        dotLayer.cornerRadius = param.dotRadius
        dotLayer.frame = dot.bounds
        dot.layer.addSublayer(dotLayer)
    }
    
    private override init() {
        super.init()
    }
    
    func clear() {
        dot.removeFromSuperview()
     }
    
    func move(_ param: MoveAnimationParam) {
        dot.center = param.position!
    }
}
