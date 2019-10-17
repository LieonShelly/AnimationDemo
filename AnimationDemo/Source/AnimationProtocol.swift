//
//  AnimationProtocol.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

protocol PanParam: AnimationParam {
    var points: [CGPoint]! { get set }
    var dotStartFillColor: UIColor! { get set }
    var dotEndFillColor: UIColor! { get set }
    var dotStartBorderColor: UIColor! { get set }
    var dotEndBorderColor: UIColor! { get set }
    var dotRadius: CGFloat! { get set}
    var dotBorderWidth: CGFloat! { get set }
    var dotMoveColor: UIColor! { get set }
    var speed: Int! { get set }
    
    mutating func initial()
}

extension PanParam {
    mutating func initial() {
        self.dotRadius = 20
        self.dotBorderWidth = 3
        self.speed = 200
        self.dotStartFillColor = UIColor.gray
        self.dotEndFillColor = UIColor.gray
        self.dotStartBorderColor = UIColor.white
        self.dotEndBorderColor = UIColor.white
        self.dotMoveColor = UIColor.white
    }
}

protocol AnimationTargetType: AnimationBase {
    var layer: CALayer! { get set }
    var animationCompletion: ((Bool) -> Void)? { get set }
    
    func clear()
}

protocol AnimationParam {
    var layer: CALayer! { get set }    
}

protocol TapAnimationParam: AnimationParam {
    var duration: Double! { get set }
    var color: UIColor! { get set }
    var fromPoint: CGPoint? { get set }
    var endPoint: CGPoint? { get set }
}

extension TapAnimationParam {
    var duration: Double? {
        return 0.25
    }
    var color: UIColor? {
        return .white
    }
}

protocol AnimationBase {
    func delay(seconds: Double, completion: @escaping ()-> Void)
}

extension AnimationBase {

    func delay(seconds: Double, completion: @escaping ()-> Void) {
      DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }

}

