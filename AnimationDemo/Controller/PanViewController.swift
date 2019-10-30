//
//  PanViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class PanViewController: UIViewController {
    @IBOutlet weak var animationView: TouchView!
    fileprivate lazy var dot: CAShapeLayer = {
        let dot = CAShapeLayer()
        dot.backgroundColor = UIColor.gray.cgColor
        return dot
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dot.position = animationView.center
    }
    
    @IBAction func enterAction(_ sender: Any) {
        var param = CommonPanAnimationParam(animationView.layer,
                                            points: animationView.currentHandlePoints)
        param.dotStartFillColor = UIColor.white.withAlphaComponent(0.5)
        param.dotMoveColor = UIColor.white.withAlphaComponent(0.5)
        param.dotEndFillColor = UIColor.white.withAlphaComponent(0.5)
        param.dotStartBorderColor = .white
        param.dotEndBorderColor = .white
        param.speed = 50
        /**
            可以单独设置参数：
            param.dotStartFillColor = .red
            param.dotMoveColor = .yellow
            param.dotEndFillColor = .purple
            param.dotStartBorderColor = .brown
            param.dotEndBorderColor = .blue
            param.dotRadius = 50
            param.dotBorderWidth = 20
         */
        IFAnimation.show(.pan(param)) { (_) in
            debugPrint("complete")
         }
    }
    
    
    private func setupDemoUI() {
        dot.cornerRadius = 20
        dot.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        dot.borderColor = UIColor.white.cgColor
        dot.borderWidth = 3
        dot.opacity = 0
        animationView.layer.addSublayer(dot)
    }
    
    private func showDemoAction() {
        let showScaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        showScaleAnimation.fromValue = 0
        showScaleAnimation.toValue = 1.5
        showScaleAnimation.duration = 0.5
        showScaleAnimation.beginTime = CACurrentMediaTime()
        showScaleAnimation.fillMode = .forwards
        showScaleAnimation.isRemovedOnCompletion = false
        showScaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        dot.opacity = 1
        dot.add(showScaleAnimation, forKey: nil)

        let group = CAAnimationGroup()
        group.fillMode = .forwards
        group.beginTime = CACurrentMediaTime() + 0.5
        group.duration = 0.5
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


        let position = CABasicAnimation(keyPath: "position")
        position.fillMode = .forwards
        position.beginTime = CACurrentMediaTime() + 1
        position.duration = 1
        position.toValue = CGPoint(x: animationView.frame.maxX - 100, y: animationView.frame.maxY - 100)
        position.isRemovedOnCompletion = false
        dot.add(position, forKey: nil)

        let dismissBgColorAnima = CABasicAnimation(keyPath: "backgroundColor")
        dismissBgColorAnima.toValue = UIColor.white.cgColor
        dismissBgColorAnima.toValue = UIColor.gray

        let borderWidth = CABasicAnimation(keyPath: "borderWidth")
        borderWidth.fromValue = 0
        borderWidth.toValue = 3

        let dismissScale = CABasicAnimation(keyPath: "transform.scale")
        dismissScale.fromValue = 1
        dismissScale.toValue = 4

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0

        group.beginTime = CACurrentMediaTime() + 1 + 1
        group.animations = [borderColorAnima,
                          dismissBgColorAnima,
                          borderWidth,
                          dismissScale,
                          opacity]
        dot.add(group, forKey: nil)
    }
    
    @IBAction func clear(_ sender: Any) {
        animationView.clear()
    }
}
