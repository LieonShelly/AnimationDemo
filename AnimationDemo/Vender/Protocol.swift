//
//  Protocol.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

protocol DemoUIControl {
    var startX: UITextField! { get set }
    var endY: UITextField! { get set }
    var endX: UITextField! { get set }
    var startY: UITextField! { get set }
    var pointCunt: UITextField! { get set }
    var animationView: TouchView! { get set }
    
    func getDemoPoints() -> [CGPoint]
     
}

extension DemoUIControl {
    func getDemoPoints() -> [CGPoint] {
      guard let startXStr = startX.text,
         let startYStr = startY.text,
         let endXStr = endX.text,
         let endYStr = endY.text,
         let countStr = pointCunt.text else {
             return []
         }
       guard let startPointX = Float(startXStr),
         let startPointY = Float(startYStr),
         let endPointX = Float(endXStr),
         let endPointY = Float(endYStr),
         let count = Int(countStr) else {
             return []
         }
         let startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
         let endPoint = CGPoint(x: CGFloat(endPointX), y: CGFloat(endPointY))
         let points = startPoint.randomPoinits(endPoint: endPoint, pointCount: count)
        return points
    }
}
