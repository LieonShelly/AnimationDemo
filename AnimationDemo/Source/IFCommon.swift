//
//  IFCommon.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/15.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import  UIKit

class IFCommonAnimateParam: IFAnimationParam {
    var fromPoint: CGPoint?
    var endPoint: CGPoint?
    var color: UIColor! = UIColor.gray
    var duration: Double! = 0.5
    var layer: CALayer!
    
    init(_ layer: CALayer) {
        self.layer = layer
    }
}
