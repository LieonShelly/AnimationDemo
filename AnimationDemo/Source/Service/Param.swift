//
//  Param.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/24.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

struct CommonTipPopParam: TipPopParam {
    var backgroundColor: UIColor! = UIColor.black.withAlphaComponent(0.3)
    var fillColor: UIColor! = UIColor.white
    var textParam: TipPopTextAttribute?
    var displayView: UIView?
    var minInset: CGFloat! = 10
    var priorityDirection: ArrowDirection!
    var direction: ArrowDirection! = .top
    var arrowPosition: CGPoint!
    var arrorwSize: CGSize! = CGSize(width: 10, height: 10)
    var cornorRadius: CGFloat! = 3
    var popRect: CGRect!
    var borderColor: UIColor! = UIColor.clear
    var borderWidth: CGFloat! = 1
    var popSize: CGSize! = CGSize(width: 200, height: 100)
}

struct CommonTipPopTextParam: TipPopTextAttribute {
    var lineSpacing: CGFloat! = 10
    var sizeLimitType: TipPopTextSizeLimitType! = .width(200)
    var textColor: UIColor! = UIColor.black
    var font: UIFont! = UIFont.boldSystemFont(ofSize: 14)
    var textAlignment: NSTextAlignment! = .center
    var text: String?
    var backgroudColor: UIColor? = .clear
}
