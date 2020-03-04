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
        progressLayer.strokeColor = UIColor.red.cgColor
        progressLayer.lineWidth = 3
        progressLayer.lineCap = .round
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0.5
        return progressLayer
    }()
  
    fileprivate lazy var numberView: FXTutorialNumView = {
        let numberView = FXTutorialNumView()
        numberView.backgroundColor = UIColor.red.withAlphaComponent(0.4)
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
        progressLayer.frame = layer.bounds
        let cyclePath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width * 0.5).cgPath
        progressLayer.path = cyclePath
        numberView.frame.size = CGSize(width: bounds.width - 5, height: bounds.height - 5)
        numberView.center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        numberView.layer.cornerRadius = (bounds.width - 5) * 0.5
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
            lineWidth.fromValue = 3
            lineWidth.toValue = 1
            lineWidth.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            lineWidth.fillMode = .backwards
            lineWidth.setValue("lineWidth", forKey: "name")
            lineWidth.duration = 0.25
            lineWidth.delegate = self
            progressLayer.add(lineWidth, forKey: nil)
            self.animationEnd = compeletion
        } else {
            progressLayer.lineWidth = 3
        }
    }
    
}

extension FXTutorialStepNumView {
    @objc
    fileprivate func btnClick() {
        clickAction?()
    }
}


