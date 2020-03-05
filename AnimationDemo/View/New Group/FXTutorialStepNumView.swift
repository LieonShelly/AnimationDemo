//
//  FXTutorialStepNumView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/4.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation
import UIKit

class FXTutorialStepNumView: UIView {
    var clickAction: (() -> ())?
    fileprivate lazy var btn: UIButton = {
        let btn = UIButton(type: .custom)
        return btn
    }()
    lazy var progressLayer: CAShapeLayer = {
        let progressLayer = CAShapeLayer()
        progressLayer.strokeColor = UIColor(hex: 0xf65685)!.cgColor
        progressLayer.lineWidth = 3.2
        progressLayer.lineCap = .round
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0.5
        return progressLayer
    }()
  
    fileprivate lazy var numberView: FXTutorialNumView = {
        let numberView = FXTutorialNumView()
        numberView.backgroundColor = UIColor(red: 37 / 255.0, green: 37 / 255.0, blue: 37 / 255.0, alpha: 0.16)
        return numberView
    }()

    fileprivate var animationEnd: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(numberView)
        layer.addSublayer(progressLayer)
        addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        btn.frame = bounds
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let pathSize = CGSize(width: 44 + 3.2, height: 44 + 3.2)
        
        let cyclePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 3.2 * 0.5, y: 3.2 * 0.5), size: pathSize),
                                     cornerRadius: pathSize.width * 0.5).cgPath
        progressLayer.path = cyclePath
        numberView.frame.size = CGSize(width: 44, height: 44)
        numberView.center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        numberView.layer.cornerRadius = 44 * 0.5
        numberView.layer.masksToBounds = true
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FXTutorialStepNumView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let lineWidth = anim.value(forKey: "name") as? String, lineWidth == "lineWidth" {
            animationEnd?()
        }
    }
}

extension FXTutorialStepNumView {
    /// progress为1时，动画完成会回调
    func update(_ progress: CGFloat, compeletion: (() -> ())? = nil) {
        progressLayer.strokeEnd = progress
        if progress >= 1 {
            let lineWidth = CABasicAnimation(keyPath: "lineWidth")
            lineWidth.fromValue = 3.2
            lineWidth.toValue = 0
            lineWidth.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            lineWidth.fillMode = .forwards
            lineWidth.isRemovedOnCompletion = false
            lineWidth.setValue("lineWidth", forKey: "name")
            lineWidth.duration = 0.25
            lineWidth.delegate = self
            progressLayer.add(lineWidth, forKey: nil)
            self.animationEnd = compeletion
        } else {
            progressLayer.removeAllAnimations()
            progressLayer.lineWidth = 3.2
        }
    }
    
}

extension FXTutorialStepNumView {
    @objc
    fileprivate func btnClick() {
        clickAction?()
    }
}


