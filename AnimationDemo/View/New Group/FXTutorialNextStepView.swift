//
//  FXTutorialNextStepView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/4.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation
import UIKit

class FXTutorialNextStepView: UIView {
    var scaleAnimationEnd: (() -> ())?
    fileprivate lazy var nextBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("下一步", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 15, isBold: true)
        btn.layer.opacity = 0
        btn.addTarget(self, action: #selector(nextBtnAction), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var progressLayer: CAShapeLayer = {
        let progressLayer = CAShapeLayer()
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = 2
        progressLayer.lineCap = .round
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 1
        progressLayer.opacity = 0
        return progressLayer
    }()
    
    fileprivate lazy var scaleView: FXScaleView = {
        let scaleView = FXScaleView()
        scaleView.backgroundColor = .red
        scaleView.layer.cornerRadius = 50 * 0.5
        scaleView.layer.masksToBounds = true
        scaleView.alpha = 0
        scaleView.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
        return scaleView
    }()
    
    fileprivate var isNeedLayout: Bool = true
    
    fileprivate var zoomOutEnd: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scaleView)
        layer.addSublayer(progressLayer)
        addSubview(nextBtn)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isNeedLayout {
            scaleView.frame = CGRect(x: bounds.width - 50, y: 0, width: 50, height: 50)
            nextBtn.layer.position.y = bounds.height * 0.7
            nextBtn.frame = CGRect(x: bounds.width - 45 - 25, y: (bounds.height - 40) * 0.5, width: 45, height: 40)
        }
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if isNeedLayout {
            progressLayer.frame = CGRect(x: bounds.width - 50, y: 0, width: 50, height: 50)
            let hookPath = UIBezierPath()
            
            hookPath.move(to: CGPoint(x: 25, y: 0))
            hookPath.addCurve(to: CGPoint(x: 13, y: 8), controlPoint1: CGPoint(x: 25, y: 0), controlPoint2: CGPoint(x: 16, y: 2.75))
            hookPath.addCurve(to: CGPoint(x: 13, y: 21), controlPoint1: CGPoint(x: 10, y: 13.25), controlPoint2: CGPoint(x: 13, y: 21))
            hookPath.addLine(to: CGPoint(x: 22, y: 32))
            hookPath.addLine(to: CGPoint(x: 38, y: 14))
            progressLayer.path = hookPath.cgPath
        }
      
    }
    
    func showAnimation() {
        /// 出现
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scaleView.alpha = 1
        scale.fromValue = 0.5
        scale.toValue = 1
        scale.fillMode = .backwards
        scale.duration = 0.25
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.setValue("scaleAnimation", forKey: "name")
        scale.delegate = self
        scaleView.layer.add(scale, forKey: nil)
        scaleView.layer.transform = CATransform3DMakeScale(1, 1, 1)
    }
    
    fileprivate func startHookAnimation() {
        progressLayer.opacity = 1
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 0.4
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1.0
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 0.5
        strokeAnimationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeAnimationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        strokeAnimationGroup.delegate = self
        strokeAnimationGroup.setValue("hookAnimation", forKey: "name")
        progressLayer.add(strokeAnimationGroup, forKey: nil)
        progressLayer.strokeStart = 0.5
        progressLayer.strokeEnd = 1
    }
    
    fileprivate  func expandBoundsAnimation() {
        let scaleViewboundsAni = CABasicAnimation(keyPath: "bounds")
        scaleViewboundsAni.fromValue = self.scaleView.bounds
        scaleViewboundsAni.toValue = self.bounds
        scaleViewboundsAni.duration = 0.5
        scaleViewboundsAni.fillMode = .forwards
        scaleViewboundsAni.isRemovedOnCompletion = true
        scaleViewboundsAni.delegate = self
        scaleViewboundsAni.setValue("boundsAnimation", forKey: "name")
        scaleViewboundsAni.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        isNeedLayout = false
        scaleView.setAnchorPoint(CGPoint(x: 1, y: 0.5))
        scaleView.layer.add(scaleViewboundsAni, forKey: nil)
        
        let hookViewPosition = CABasicAnimation(keyPath: "position.x")
        hookViewPosition.fromValue = bounds.width - 50 * 0.5
        hookViewPosition.toValue = 25
        
        let hookScale = CABasicAnimation(keyPath: "transform.scale")
        hookScale.fromValue = 1
        hookScale.toValue = 0.8
        
        let hookGrop = CAAnimationGroup()
        hookGrop.fillMode = .forwards
        hookGrop.isRemovedOnCompletion = false
        hookGrop.duration = 0.5
        hookGrop.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        hookGrop.animations = [hookViewPosition, hookScale]
        progressLayer.add(hookGrop, forKey: nil)
    }
    
    fileprivate  func showNextbtn() {
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0
        opacity.toValue = 1
        opacity.fillMode = .forwards
        opacity.isRemovedOnCompletion = false
        opacity.duration = 0.05
        
        let btnPositionY = CABasicAnimation(keyPath: "position.y")
        btnPositionY.fromValue = bounds.height * 0.7
        btnPositionY.toValue = bounds.height * 0.5
        btnPositionY.fillMode = .backwards
        btnPositionY.isRemovedOnCompletion = false
        
        let group = CAAnimationGroup()
        group.duration = 0.25
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false
        group.animations = [opacity, btnPositionY]
        
        nextBtn.layer.add(group, forKey: nil)
        nextBtn.layer.position.y = bounds.height * 0.5
        nextBtn.layer.opacity = 1
    }
    
    fileprivate func dismissNextBtn() {
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0
        opacity.fillMode = .backwards
        opacity.isRemovedOnCompletion = false
        
        let btnPositionY = CABasicAnimation(keyPath: "position.y")
        btnPositionY.fromValue = bounds.height * 0.5
        btnPositionY.toValue = bounds.height * 0.3
        btnPositionY.fillMode = .forwards
        btnPositionY.isRemovedOnCompletion = false
        
        let group = CAAnimationGroup()
        group.duration = 0.25
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .forwards
        group.delegate = self
        group.setValue("dismissNextBtn", forKey: "name")
        group.isRemovedOnCompletion = false
        group.animations = [opacity, btnPositionY]
        
        nextBtn.layer.add(group, forKey: nil)
        nextBtn.layer.position.y = bounds.height * 0.3
        nextBtn.layer.opacity = 0
    }
    
    fileprivate func zoomOutAnimation() {
        let scaleViewboundsAni = CABasicAnimation(keyPath: "bounds")
        scaleViewboundsAni.fromValue = self.bounds
        scaleViewboundsAni.toValue = CGRect(x: bounds.width - 50, y: 0, width: 50, height: 50)
        scaleViewboundsAni.duration = 0.5
        scaleViewboundsAni.fillMode = .forwards
        scaleViewboundsAni.isRemovedOnCompletion = true
        scaleViewboundsAni.delegate = self
        scaleViewboundsAni.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        isNeedLayout = false
        scaleView.setAnchorPoint(CGPoint(x: 1, y: 0.5))
        scaleView.layer.add(scaleViewboundsAni, forKey: nil)
        
        let hookViewPosition = CABasicAnimation(keyPath: "position.x")
        hookViewPosition.fromValue = 25
        hookViewPosition.toValue =  bounds.width - 50 * 0.5
        hookViewPosition.fillMode = .forwards
        
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0
        opacity.fillMode = .backwards
        opacity.isRemovedOnCompletion = false
        
        let group = CAAnimationGroup()
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .forwards
        group.delegate = self
        group.setValue("zoomOutAnimation", forKey: "name")
        group.isRemovedOnCompletion = false
        group.animations = [opacity, hookViewPosition]
        progressLayer.add(group, forKey: nil)
    }
    
    @objc
    fileprivate func nextBtnAction() {
        dismissNextBtn()
    }
}

extension FXTutorialNextStepView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag == true else {
            return
        }
        if let name = anim.value(forKey: "name") as? String?, name == "scaleAnimation" {
            scaleAnimationEnd?()
            startHookAnimation()
        } else if let name = anim.value(forKey: "name") as? String?, name == "hookAnimation" {
            expandBoundsAnimation()
        } else if let name = anim.value(forKey: "name") as? String?, name == "boundsAnimation" {
            scaleView.frame = self.bounds
            scaleView.setNeedsLayout()
            showNextbtn()
        } else if let name = anim.value(forKey: "name") as? String?, name == "dismissNextBtn" {
            zoomOutAnimation()
        } else if let name = anim.value(forKey: "name") as? String?, name == "zoomOutAnimation" {
            scaleView.frame = CGRect(x: bounds.width - 50, y: 0, width: 50, height: 50)
            scaleView.setNeedsLayout()
            scaleView.showCoverAnimation()
            scaleView.coverAnimationEnd = {[weak self] in
                guard let weakSelf = self else {
                    return
                }
                /// 还原所有的初始配置，为下一次动画做准备
                weakSelf.scaleView.alpha = 0
                weakSelf.scaleView.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
                weakSelf.progressLayer.removeAllAnimations()
                weakSelf.progressLayer.opacity = 0
            }
        }
    }
}
