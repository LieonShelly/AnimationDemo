//
//  PinchViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/9.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class PinchViewController: UIViewController {

    fileprivate lazy var dot1: CALayer = {
        let dot1 = CALayer()
        dot1.contents = UIImage(named: "circle_gray")?.cgImage
        return dot1
    }()
    fileprivate lazy var dot2: CALayer = {
        let dot1 = CALayer()
        dot1.contents = UIImage(named: "circle_gray")?.cgImage
        return dot1
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let startPoint = touch.location(in: view)
        IFPinchAnimation.showDot(in: view.layer, centerPoint: view.center, point: startPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
                 return
          }
         let startPoint = touch.location(in: view)
         IFPinchAnimation.showDot(in: view.layer, centerPoint: view.center, point: startPoint)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

extension PinchViewController {
  
}


extension CGPoint {
    
    func symmetricPoint(with centerPoint: CGPoint) -> CGPoint {
        return CGPoint(x: 2 * centerPoint.x - x, y: 2 * centerPoint.y - y)
    }

}
