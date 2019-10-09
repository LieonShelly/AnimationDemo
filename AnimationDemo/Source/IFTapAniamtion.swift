//
//  IFTapAniamtion.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/9.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

class IFTapAniamtion {
    
    static func jumpSpring(layer: CALayer) {
        let jump = CASpringAnimation(keyPath: "position.y")
        jump.fromValue = layer.position.y + 1
        jump.toValue = layer.position.y
        jump.duration = jump.settlingDuration
        jump.initialVelocity = 100.0
        jump.mass = 10
        jump.stiffness = 15000
        jump.damping = 50
        layer.add(jump, forKey: nil)

    }
}
