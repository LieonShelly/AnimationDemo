//
//  AnimationProtocol.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

/// 互动教程动画类型
enum IFTeachAnaimationType {
    /// 放缩相关
    case pinch(PinchParam)
    /// 拖拽涂抹相关
    case pan(PanParam)
    /// 点击相关
    case tap(TapAnimationParam)
}

/// 动画接口规范
protocol AnimationInterface {
    /// 当前动画所需要的参数-外部规定
    associatedtype AnimationParam
    
    /// 动画实现的方法-外部决定具体效果
    @discardableResult
    static func show(_ param: AnimationParam, completion: ((Bool) -> Void)?) -> String
}

/// 放缩类的动画参数
protocol PinchParam: AnimationParam {
    /// 端点A的路径
    var pointsA: [CGPoint]! { get set }
    /// 端点B的路径
    var pointsB: [CGPoint]! { get set }
    /// 点的起始填充色
    var dotStartFillColor: UIColor! { get set }
    /// 点的动画结束时的填充色
    var dotEndFillColor: UIColor! { get set }
    /// 点的动画开始时的borderColor
    var dotStartBorderColor: UIColor! { get set }
    /// 点的动画结束时的borderColor
    var dotEndBorderColor: UIColor! { get set }
    /// 点的半径
    var dotRadius: CGFloat! { get set}
    /// 点的borderWidth
    var dotBorderWidth: CGFloat! { get set }
    /// 点移动时的颜色
    var dotMoveColor: UIColor! { get set }
    /// 点移动的速度 单位：点每秒
    var speed: Int! { get set }
}

extension PinchParam {
    mutating func initial() {
        self.dotRadius = 20
        self.dotBorderWidth = 3
        self.speed = 50
        self.dotStartFillColor = UIColor.gray
        self.dotEndFillColor = UIColor.gray
        self.dotStartBorderColor = UIColor.white
        self.dotEndBorderColor = UIColor.white
        self.dotMoveColor = UIColor.white
    }
}

/// 涂抹移动类的动画参数
protocol PanParam: AnimationParam {
    /// 采集点
    var points: [CGPoint]! { get set }
    /// 点的起始填充色
    var dotStartFillColor: UIColor! { get set }
    /// 点的动画结束时的填充色
    var dotEndFillColor: UIColor! { get set }
    /// 点的动画开始时的borderColor
    var dotStartBorderColor: UIColor! { get set }
    /// 点的动画结束时的borderColor
    var dotEndBorderColor: UIColor! { get set }
    /// 点的半径
    var dotRadius: CGFloat! { get set}
    /// 点的borderWidth
    var dotBorderWidth: CGFloat! { get set }
    /// 点移动时的颜色
    var dotMoveColor: UIColor! { get set }
    /// 点移动的速度 单位：点每秒
    var speed: Int! { get set }
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

/// 点击类的动画参数
protocol TapAnimationParam: AnimationParam {
    /// 一帧动画所需要的时间，默认为0.25
    var speed: Double! { get set }
    ///  波纹的颜色
    var color: UIColor! { get set }
    /// 动画起始点
    var fromPoint: CGPoint? { get set }
    /// 动画结束点
    var endPoint: CGPoint? { get set }
    /// 点的半径
    var dotRadius: CGFloat! { get set }
    /// 波纹的半径
    var waveRadius: CGFloat! { get set }
    /// 波纹的数量
    var waveCount: Int! { get set }
    /// 重复的次数
    var repeateCount: Float! { get set}
    
}

extension TapAnimationParam {
    var duration: Double? {
        return 0.25
    }
    var color: UIColor? {
        return .white
    }
}

protocol AnimationTargetType: AnimationBase {
    var layer: CALayer! { get set }
    var animationCompletion: ((Bool) -> Void)? { get set }
    
    func clear()
}

protocol AnimationParam {
    var layer: CALayer! { get set }
    
    mutating func initial()
}

extension AnimationParam {
    mutating func initial() {
        
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

enum ArrowDirection: Int {
    case top = 0
    case left = 1
    case bottom = 2
    case right = 3
    case none = -1
}

protocol TipPopParam {
    var backgroundColor: UIColor! { get set }
    var popSize: CGSize! { get set }
    var direction: ArrowDirection! { get set }
    var arrowPosition: CGPoint! { get set }
    var arrorwSize: CGSize! { get set }
    var cornorRadius: CGFloat! { get set }
    var popRect: CGRect! { get set }
    var fillColor: UIColor! {get set}
    var borderColor: UIColor! { get set }
    var borderWidth: CGFloat! { get set }
    var minInset: CGFloat! { get set }
    var displayView: UIView? { get set }
    var textParam: TipPopTextAttribute? { get set }
}

protocol TipPopTextAttribute {
    var font: UIFont! { get set }
    var textColor: UIColor! { get set }
    var textAlignment: NSTextAlignment! { get set }
    var text: String? { get set }
    var backgroudColor: UIColor? { get set }
    var lineSpacing: CGFloat! { get set }
    var sizeLimitType: TipPopTextSizeLimitType! { get set }
}

enum TipPopTextSizeLimitType {
    case width(CGFloat)
    case height(CGFloat)
    case none
    
    var value: CGFloat {
        switch self {
        case .width(let value):
            return value
        case .height(let value):
            return value
        case .none:
            return 0
        }
    }
}
