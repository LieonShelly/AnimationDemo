//
//  Common.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/15.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import  UIKit

class CommonAnimateParam: TapAnimationParam {
    var repeateCount: Float! = 30
    var waveRadius: CGFloat! = 10
    var fromPoint: CGPoint?
    var endPoint: CGPoint?
    var color: UIColor! = UIColor.gray
    var speed: Double! = 0.25
    var layer: CALayer!
    var dotRadius: CGFloat! = 20
    var waveCount: Int! = 5
    
    init(_ layer: CALayer) {
        self.layer = layer
    }
}

struct CommonPanAnimationParam: PanParam {
    var dotStartFillColor: UIColor!
    var dotEndFillColor: UIColor!
    var dotStartBorderColor: UIColor!
    var dotEndBorderColor: UIColor!
    var dotBorderWidth: CGFloat!
    var dotMoveColor: UIColor!
    var speed: Int!
    var dotRadius: CGFloat!
    var dotBorderColor: UIColor!
    var dotFillColor: UIColor!
    var points: [CGPoint]!
    var layer: CALayer!
    
    init(_ layer: CALayer, points: [CGPoint]) {
        self.layer = layer
        self.points = points
        self.initial()
    }
    
}


struct CommonPinchAnimationParam: PinchParam {
    var dotStartFillColor: UIColor!
    var dotEndFillColor: UIColor!
    var dotStartBorderColor: UIColor!
    var dotEndBorderColor: UIColor!
    var dotBorderWidth: CGFloat!
    var dotMoveColor: UIColor!
    var speed: Int!
    var dotRadius: CGFloat!
    var dotBorderColor: UIColor!
    var dotFillColor: UIColor!
    var pointsA: [CGPoint]!
    var pointsB: [CGPoint]!
    var layer: CALayer!
    
    init(_ layer: CALayer, pointsA: [CGPoint], pointsB: [CGPoint]) {
        self.layer = layer
        self.pointsA = pointsA
        self.pointsB = pointsB
        self.initial()
    }
    
}
