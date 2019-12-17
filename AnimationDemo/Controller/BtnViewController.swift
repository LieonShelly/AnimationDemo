//
//  BtnViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/25.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class BtnViewController: UIViewController {
    var destinationRect = CGRect(x: UIScreen.main.bounds.width - 100, y: 100, width: 44, height: 44)
    lazy var gradientLayer: CAGradientLayer = {
          let layer = CAGradientLayer()
          layer.colors = [#colorLiteral(red: 0.4784313725, green: 0.8274509804, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.2549019608, blue: 0.8274509804, alpha: 1).cgColor]
          layer.startPoint = CGPoint(x: 0, y: 0)
          layer.endPoint = CGPoint(x: 1, y: 0)
          return layer
      }()
      
    
       lazy var shapeLapyer: CAShapeLayer = {
           let shapeLayer = CAShapeLayer()
           shapeLayer.fillColor = UIColor.clear.cgColor
           shapeLayer.strokeColor = UIColor.black.cgColor
           return shapeLayer
       }()
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton(type: .custom)
        let btnBounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        btn.frame.size = btnBounds.size
        btn.center = view.center
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 30
        btn.layer.shadowPath = CGPath(roundedRect: btnBounds,
                                      cornerWidth: 30,
                                      cornerHeight: 30, transform: nil)
        btn.layer.shadowColor = UIColor.red.cgColor
        btn.layer.shadowOffset = .zero
        btn.layer.shadowRadius = 10
        btn.layer.shadowOpacity = 1
        view.addSubview(btn)
      
        let layerAnimation = CABasicAnimation(keyPath: "shadowRadius")
        layerAnimation.fromValue = 10
        layerAnimation.toValue = 1
        layerAnimation.autoreverses = true
        layerAnimation.isAdditive = false
        layerAnimation.duration = 0.25
        layerAnimation.fillMode = .forwards
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.repeatCount = .infinity
        btn.layer.add(layerAnimation, forKey: nil)
        
        shapeLapyer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: destinationRect.height, height: destinationRect.height), cornerRadius: destinationRect.height * 0.5).cgPath
        shapeLapyer.lineWidth = 5
        gradientLayer.frame = destinationRect
        gradientLayer.removeAllAnimations()
        gradientLayer.mask = shapeLapyer
        gradientLayer.cornerRadius = destinationRect.height * 0.5
        view.layer.addSublayer(gradientLayer)
    }
    
}
