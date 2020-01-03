//
//  IFHookMarkView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/1/2.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class IFHookMarkView: UIView {

    fileprivate lazy var shapelayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 1.4
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.strokeEnd = 0
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(shapelayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        debugPrint("bounds:\(bounds)")
        let rect = bounds
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: rect.height * 0.6))
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        shapelayer.path = path.cgPath
    }
    

    func showAnimation() {
        UIApplication.openSettingsURLString
        shapelayer.strokeEnd = 1
        let group = CAAnimationGroup()
        group.duration = 0.25
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.fromValue = 0
        strokeEnd.toValue = 1
        strokeEnd.duration = 0.25
        strokeEnd.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 1.2
        scale.fillMode = .forwards
        scale.isRemovedOnCompletion = false
        scale.duration = 0.1
        
        group.animations = [strokeEnd]
        shapelayer.add(group, forKey: nil)
        
        scale.beginTime = CACurrentMediaTime() + 0.25
        scale.fromValue = 1
        scale.toValue = 0.9
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        shapelayer.add(scale, forKey: nil)
        
    }
    
}
