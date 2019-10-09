//
//  IFPinchAnimation.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/9.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

class IFPinchAnimation {
    static var anmationKeys: [String: Any] = [:]
    
    static func showDot(in layer: CALayer, centerPoint: CGPoint, point: CGPoint) {
        let name = layer.description
        if let existHelper = anmationKeys[name] as? PinchHelper {
            existHelper.showDot(point, center: centerPoint)
        } else {
          let helper = PinchHelper(layer)
          helper.showDot(point, center: centerPoint)
          anmationKeys[name] = helper
        }
    }
}


class PinchHelper {
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
    
    var layer: CALayer
    
    init(_ layer: CALayer) {
        self.layer = layer
        dot2.bounds = CGRect(x: 110, y: 0, width: 50, height: 50)
        dot1.bounds = CGRect(x: 220, y: 0, width: 50, height: 50)
        layer.addSublayer(dot1)
        layer.addSublayer(dot2)
    }
    
    fileprivate func showDot(_ startPoint: CGPoint, center: CGPoint) {
        dot1.position = startPoint
        let endPoint = startPoint.symmetricPoint(with: center)
        dot2.position = endPoint

        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.fromValue = dot1.position
        positionAnimation.toValue = startPoint
        positionAnimation.duration = 0.25
        dot1.add(positionAnimation, forKey: nil)

        positionAnimation.fromValue = dot2.position
        positionAnimation.toValue = endPoint
        dot2.add(positionAnimation, forKey: nil)
       
        }
}
