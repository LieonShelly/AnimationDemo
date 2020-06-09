//
//  FXTutorialManulVideoIcon.swift
//  PgImageProEditUISDK
//
//  Created by lieon on 2020/3/12.
//

import Foundation
import UIKit

class FXTutorialManulVideoIcon: UIButton {
    
    struct UISize {
        static let iconSize: CGSize = CGSize(width: 42.fitiPhone5sSerires, height: 42.fitiPhone5sSerires)
        static let cycleWidth: CGFloat = 52.fitiPhone5sSerires
        static let lineWidth: CGFloat = 1.5
        static let lineMaxWidth: CGFloat = 2
    }
    var cllickAction: (() -> Void)?
    var showSuccessHandler: (() -> Void)?

    fileprivate lazy var gradientimageView: FXManualVideoGradientBtn = {
        let imageView = FXManualVideoGradientBtn()
        imageView.isUserInteractionEnabled = true
        imageView.gradientLayer.colors = [UIColor(hex: 0xd996fb)!.cgColor, UIColor(hex: 0xa199f5)!.cgColor]
        imageView.gradientLayer.endPoint = CGPoint(x: 1, y: 0.8)
        imageView.gradientLayer.cornerRadius = UISize.iconSize.width * 0.5
        return imageView
    }()
//    fileprivate lazy var container: UIView = {
//        let container = UIView()
//        container.layer.cornerRadius = UISize.iconSize.width * 0.5
//        container.layer.masksToBounds = true
//        container.isUserInteractionEnabled = false
//        return container
//    }()
      fileprivate lazy var shapeLayer: CAShapeLayer = {
         let cycleLayer = CAShapeLayer()
         cycleLayer.strokeColor = UIColor(hex: 0xC47AFF)?.cgColor
         cycleLayer.lineWidth = UISize.lineWidth
         cycleLayer.fillColor = UIColor.clear.cgColor
         return cycleLayer
     }()
     fileprivate lazy var grdientLayer: CAGradientLayer = {
         let grdientLayer = CAGradientLayer()
         grdientLayer.colors = [UIColor(hex: 0xd996fb)!.cgColor, UIColor(hex: 0xa199f5)!.cgColor]
         grdientLayer.startPoint = CGPoint(x: 0, y: 0.2)
         grdientLayer.endPoint = CGPoint(x: 1, y: 0.8)
         return grdientLayer
     }()
    fileprivate var isLoopAnimating: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(grdientLayer)
        addSubview(gradientimageView)
        gradientimageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(UISize.iconSize)
        }
        addTarget(self, action: #selector(iconAction), for: .touchUpInside)
        reset()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        shapeLayer.lineWidth = 1.5
        let destinationRect = CGRect(x: bounds.width * 0.5 - UISize.cycleWidth * 0.5, y: bounds.height * 0.5 - UISize.cycleWidth * 0.5, width: UISize.cycleWidth, height: UISize.cycleWidth)
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: destinationRect.height, height: destinationRect.height), cornerRadius: destinationRect.height * 0.5).cgPath
        grdientLayer.mask = shapeLayer
        grdientLayer.cornerRadius = destinationRect.height * 0.5
        grdientLayer.frame = destinationRect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
          return self
      }
}

extension FXTutorialManulVideoIcon {
 
    func show() {
        if isLoopAnimating {
            return
        }
        alpha = 1
        showIconAnimaton()
    }
    
    func dismiss() {
        dismissAnimation()
    }
}

extension FXTutorialManulVideoIcon {
    
    @objc
    fileprivate func iconAction() {
        cllickAction?()
    }
    
    fileprivate func iconShowRloop() {
        isLoopAnimating = true
        gradientimageView.layer.opacity = 1
        let containerScale = CAKeyframeAnimation(keyPath: "transform.scale")
        containerScale.values = [1, 0.8]
        containerScale.calculationMode = .linear
        containerScale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        containerScale.duration = 0.5
        containerScale.delegate = self
        containerScale.repeatCount = .infinity
        containerScale.fillMode = .forwards
        containerScale.isRemovedOnCompletion = false
        containerScale.setValue("iconShowRoolp", forKey: "name")
        containerScale.autoreverses = true
        containerScale.repeatCount = 2
        gradientimageView.layer.add(containerScale, forKey: nil)
        
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [1, 0.5]
        opacity.calculationMode = .linear
        opacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        opacity.duration = 0.5
        opacity.delegate = self
        opacity.repeatCount = .infinity
        opacity.fillMode = .forwards
        opacity.isRemovedOnCompletion = false
        opacity.rotationMode = .rotateAutoReverse
        opacity.autoreverses = true
        
        let lineWidth = CAKeyframeAnimation(keyPath: "lineWidth")
        lineWidth.values = [UISize.lineWidth, UISize.lineMaxWidth]
        lineWidth.calculationMode = .linear
        lineWidth.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let group = CAAnimationGroup()
        group.beginTime = CACurrentMediaTime()
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.duration = 0.5
        group.fillMode = .forwards
        group.repeatCount = 2
        group.isRemovedOnCompletion = false
        group.delegate = self
        group.autoreverses = true
        group.animations = [opacity, lineWidth]
        shapeLayer.add(group, forKey: nil)
    }
    
    fileprivate func showIconAnimaton() {
        gradientimageView.layer.opacity = 1
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [0, 1, 1.5, 1, 0.8, 1]
        scale.calculationMode = .linear
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.duration = 0.5
        scale.delegate = self
        scale.fillMode = .forwards
        scale.isRemovedOnCompletion = false
        scale.setValue("showIconAnimaton", forKey: "name")
        gradientimageView.layer.add(scale, forKey: nil)
    }
    
    fileprivate func dismissAnimation() {
        isLoopAnimating = false
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [1, 1.5, 0]
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.isRemovedOnCompletion = false
        scale.duration = 0.5
        scale.delegate = self
        scale.fillMode = .forwards
        scale.setValue("dismissAnimation", forKey: "name")
        gradientimageView.layer.add(scale, forKey: nil)
        grdientLayer.add(scale, forKey: nil)
    }
    
    func reset() {
        isLoopAnimating = false
        isUserInteractionEnabled = false
        alpha = 0
        shapeLayer.lineWidth = UISize.lineWidth
        grdientLayer.removeAllAnimations()
        gradientimageView.layer.removeAllAnimations()
    }
}

extension FXTutorialManulVideoIcon: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let name = anim.value(forKey: "name") as? String, name == "dismissAnimation" {
            reset()
        } else if let name = anim.value(forKey: "name") as? String, name == "showIconAnimaton" {
            isUserInteractionEnabled = true
            showSuccessHandler?()
            iconShowRloop()
        }
    }
}
