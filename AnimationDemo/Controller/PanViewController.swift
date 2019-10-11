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
    
    fileprivate lazy var dot1: CALayer = {
           let dot1 = CALayer()
           dot1.contents = UIImage(named: "circle_gray")?.cgImage
           return dot1
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dot1.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        animationView.layer.addSublayer(dot1)
        
    }
    
    @IBAction func enterAction(_ sender: Any) {
        let position = CAKeyframeAnimation(keyPath: "position")
        position.path = animationView.path.cgPath
        position.calculationMode = .linear
        let duration = Float(animationView.currentHandlePoints.count) / 50.0 // 50 个点一秒
        position.duration = CFTimeInterval(duration)
        dot1.add(position, forKey: nil)
    }
    
    @IBAction func clear(_ sender: Any) {
        animationView.clear()
    }
}
