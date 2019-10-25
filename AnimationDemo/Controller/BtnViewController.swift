//
//  BtnViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/25.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class BtnViewController: UIViewController {

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
        layerAnimation.duration = 1
        layerAnimation.fillMode = .forwards
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.repeatCount = .infinity
        btn.layer.add(layerAnimation, forKey: nil)
    }
    
}
