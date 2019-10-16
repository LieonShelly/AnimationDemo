//
//  AnimationProtocol.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

protocol AnimationTargetType: AnimationBase {
    var layer: CALayer! { get set }
    var animationCompletion: ((Bool) -> Void)? { get set }
    
    func clear()
}

protocol AnimationParam {
    var layer: CALayer! { get set }
    var duration: Double! { get set }
    var color: UIColor! { get set }
    var fromPoint: CGPoint? { get set }
    var endPoint: CGPoint? { get set }
}

protocol AnimationBase {
    func delay(seconds: Double, completion: @escaping ()-> Void)
}

extension AnimationBase {

    func delay(seconds: Double, completion: @escaping ()-> Void) {
      DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }

}

