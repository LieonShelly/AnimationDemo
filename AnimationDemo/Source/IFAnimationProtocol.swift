//
//  IFAnimationProtocol.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

protocol AnimationTargetType {
    var layer: CALayer! { get set }
    var animationCompletion: ((Bool) -> Void)? { get set }
    
    func clear()
       
}
