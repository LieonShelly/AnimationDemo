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
    fileprivate var isAnmating: Bool = false
    fileprivate lazy var nextBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("下一步", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 14, isBold: true)
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
        scaleView.backgroundColor = UIColor(hex: 0xf65685)
        scaleView.layer.cornerRadius = UISize.scaleViewSize.height * 0.5
        scaleView.layer.masksToBounds = true
        scaleView.alpha = 0
        return scaleView
    }()
    fileprivate lazy var numberView: FXTutorialNumView = {
        let numberView = FXTutorialNumView()
        numberView.backgroundColor = UIColor(hex: 0xff6e99)
        numberView.layer.opacity = 0
        return numberView
      }()
    fileprivate var isNeedLayout: Bool = true
    fileprivate var zoomOutEnd: (() -> ())?
    struct UISize {
      static let scaleViewSize: CGSize = CGSize(width: 44, height: 44)
        static let numberViewSize: CGSize = CGSize(width: 38.4, height: 38.4)
      static let nextBtnSize: CGSize = CGSize(width: 42, height: 20)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scaleView)
        layer.addSublayer(progressLayer)
        addSubview(nextBtn)
        addSubview(numberView)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isNeedLayout {
            numberView.layer.cornerRadius = UISize.numberViewSize.width * 0.5
            numberView.layer.masksToBounds = true
            scaleView.frame = CGRect(origin: CGPoint(x: bounds.width - UISize.scaleViewSize.width,
                                                               y: (bounds.height - UISize.scaleViewSize.height) * 0.5),
                                               size: UISize.scaleViewSize)
            
            numberView.frame = CGRect(origin: CGPoint(x: bounds.width - UISize.numberViewSize.width - 3,
                                                      y: (bounds.height - UISize.numberViewSize.height) * 0.5),
                                      size: UISize.numberViewSize)
            
            nextBtn.layer.position.y = bounds.height * 0.7
            nextBtn.frame = CGRect(origin: CGPoint(x: 20,
                                                   y: (bounds.height - UISize.nextBtnSize.height) * 0.5),
                                   size: UISize.nextBtnSize)
        }
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if isNeedLayout {
            progressLayer.frame = CGRect(x: bounds.width - UISize.scaleViewSize.width,
                                         y: (bounds.height - UISize.scaleViewSize.height) * 0.5,
                                         width: UISize.scaleViewSize.width,
                                         height: UISize.scaleViewSize.height)
            let hookPath = UIBezierPath()
            hookPath.move(to: CGPoint(x: 22, y: 0))
            hookPath.addCurve(to: CGPoint(x: 12, y: 9), controlPoint1: CGPoint(x: 22, y: 0), controlPoint2: CGPoint(x: 14.5, y: 3.5))
            hookPath.addCurve(to: CGPoint(x: 13, y: 20), controlPoint1: CGPoint(x: 9.5, y: 14.5), controlPoint2: CGPoint(x: 13, y: 20))
            hookPath.addLine(to: CGPoint(x: 20, y: 27))
            hookPath.addLine(to: CGPoint(x: 32, y: 16))
            progressLayer.path = hookPath.cgPath
        }
      
    }
    
    func showAnimation() {
        /// 出现
        if isAnmating {
            return
        }
        isAnmating = true
        layer.opacity = 1
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
    
    func showContinueBtn() {
        /// 出现
        if isAnmating {
            return
        }
        isAnmating = true
        layer.opacity = 1
        progressLayer.strokeColor = UIColor.clear.cgColor
        progressLayer.opacity = 0
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scaleView.alpha = 1
        scale.fromValue = 0.5
        scale.toValue = 1
        scale.fillMode = .backwards
        scale.duration = 0.25
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.setValue("showContinueBtn", forKey: "name")
        scale.delegate = self
        scaleView.layer.add(scale, forKey: nil)
        scaleView.layer.transform = CATransform3DMakeScale(1, 1, 1)
    }
    
    fileprivate func startHookAnimation() {
        progressLayer.opacity = 1
        progressLayer.strokeColor = UIColor.clear.cgColor
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
        scaleViewboundsAni.isRemovedOnCompletion = false
        scaleViewboundsAni.delegate = self
        scaleViewboundsAni.setValue("boundsAnimation", forKey: "name")
        scaleViewboundsAni.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        isNeedLayout = false
        scaleView.setAnchorPoint(CGPoint(x: 1, y: 0.5))
        scaleView.layer.add(scaleViewboundsAni, forKey: nil)
        
        let hookOpacity = CABasicAnimation(keyPath: "opacity")
        hookOpacity.fromValue = 1
        hookOpacity.toValue = 0
        hookOpacity.fillMode = .forwards
        hookOpacity.isRemovedOnCompletion = false
        hookOpacity.duration = 0.15
        hookOpacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        progressLayer.add(hookOpacity, forKey: nil)
        
        let numberViewOpacity = CABasicAnimation(keyPath: "opacity")
        numberViewOpacity.fromValue = 0
        numberViewOpacity.toValue = 1
        numberViewOpacity.fillMode = .backwards
        numberViewOpacity.isRemovedOnCompletion = false
        numberViewOpacity.beginTime = CACurrentMediaTime() + 0.1
        numberViewOpacity.duration = 0.25
        numberViewOpacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        numberView.layer.add(numberViewOpacity, forKey: nil)
        numberView.layer.opacity = 1
        
    }
    
    fileprivate  func showNextbtn() {
        isUserInteractionEnabled = true
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
        scaleViewboundsAni.toValue = CGRect(x: bounds.width - UISize.scaleViewSize.width,
                                            y: bounds.height - UISize.scaleViewSize.height,
            width: UISize.scaleViewSize.width, height: UISize.scaleViewSize.height)
        scaleViewboundsAni.duration = 0.5
        scaleViewboundsAni.fillMode = .forwards
        scaleViewboundsAni.isRemovedOnCompletion = false
        scaleViewboundsAni.delegate = self
        scaleViewboundsAni.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scaleViewboundsAni.setValue("zoomOutAnimation", forKey: "name")
        isNeedLayout = false
        scaleView.setAnchorPoint(CGPoint(x: 1, y: 0.5))
        scaleView.layer.add(scaleViewboundsAni, forKey: nil)
    }
    
    fileprivate func dismiss() {
        let numberViewOpacity = CABasicAnimation(keyPath: "opacity")
        numberViewOpacity.fromValue = 1
        numberViewOpacity.toValue = 0
        numberViewOpacity.fillMode = .backwards
        numberViewOpacity.isRemovedOnCompletion = false
        numberViewOpacity.beginTime = CACurrentMediaTime() + 0.1
        numberViewOpacity.duration = 0.1
        numberViewOpacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        numberViewOpacity.setValue("dismiss", forKey: "name")
        numberViewOpacity.delegate = self
        layer.add(numberViewOpacity, forKey: nil)
        layer.opacity = 0
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
            scaleView.frame = CGRect(x: bounds.width - 44, y: 0, width: 44, height: 44)
            dismiss()
        } else if let name = anim.value(forKey: "name") as? String?, name == "showContinueBtn" {
            scaleAnimationEnd?()
            expandBoundsAnimation()
        }  else if let name = anim.value(forKey: "name") as? String?, name == "dismiss" {
            /// 还原所有的初始配置，为下一次动画做准备
            scaleView.alpha = 0
            layer.opacity = 0
            scaleView.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
            scaleView.layer.removeAllAnimations()
            numberView.layer.removeAllAnimations()
            progressLayer.removeAllAnimations()
            layer.removeAllAnimations()
            progressLayer.opacity = 0
            isUserInteractionEnabled = false
            numberView.layer.opacity = 0
            isAnmating = false
        }
    }
}
