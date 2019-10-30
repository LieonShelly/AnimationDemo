//
//  IFAnimaton.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/30.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation

/**
互动教程动画外部接口
 */
open class IFAnimation: AnimationInterface {
    typealias AnimationParam = IFTeachAnaimationType
    
    
    @discardableResult
    static func show(_ param: AnimationParam, completion: ((Bool) -> Void)? = nil) -> String {
        switch param {
        case .tap(let tapParam):
           return TapAniamtion.showWave(with: tapParam, completion: completion)
        case .pinch(let pinchParam):
            return PinchAnimation.showKeyFrameDots(with: pinchParam, completion: completion)
        case .pan(let panParam):
            return PanAnimation.showPath(with: panParam, completion: completion)
        }
    }
}
