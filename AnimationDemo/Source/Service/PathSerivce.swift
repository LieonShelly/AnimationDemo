//
//  PathSerivce.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/24.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

class PathSerivce: NSObject {
    
    static func path(with param: TipPopParam) -> UIBezierPath {
       switch param.direction {
       case .top:
           return topArrowPath(param)
       case .left:
           return leftArrowPath(param)
       case .bottom:
           return bottomArrowPath(param)
       case .right:
           return rightArrowPath(param)
       default:
           break
       }
       return UIBezierPath()
    }

    fileprivate static func topArrowPath(_ param: TipPopParam) -> UIBezierPath {
        let path = UIBezierPath()
        guard param.direction.rawValue == ArrowDirection.top.rawValue else {
            return path
        }
        path.move(to: param.arrowPosition)
        path.addLine(to: CGPoint(x: param.arrowPosition.x - param.arrorwSize.width * 0.5, y: param.popRect.origin.y))
        path.addLine(to: CGPoint(x: param.popRect.origin.x + param.cornorRadius, y: param.popRect.origin.y))
        let topLeftArcCenter = CGPoint(x: param.popRect.origin.x + param.cornorRadius,
                  y: param.popRect.origin.y + param.cornorRadius)
        path.addArc(withCenter: topLeftArcCenter,
                      radius: param.cornorRadius,
                      startAngle: .pi * 3 / 2,
                      endAngle: .pi,
                      clockwise: false)
        path.addLine(to: CGPoint(x: param.popRect.origin.x,
                       y: param.popRect.maxY - param.cornorRadius))
        let bottomLeftArcCenter = CGPoint(x: param.popRect.origin.x + param.cornorRadius,
                                y: param.popRect.maxY - param.cornorRadius)
        path.addArc(withCenter: bottomLeftArcCenter,
                      radius: param.cornorRadius,
                      startAngle: .pi,
                      endAngle: .pi / 2,
                      clockwise: false)
        path.addLine(to: CGPoint(x: param.popRect.maxX - param.cornorRadius,
                       y: param.popRect.maxY))
        let bottomRightArcCenter = CGPoint(x: param.popRect.maxX - param.cornorRadius,
                                 y: param.popRect.maxY - param.cornorRadius)
        path.addArc(withCenter: bottomRightArcCenter,
                      radius: param.cornorRadius,
                      startAngle: .pi / 2,
                      endAngle: 0,
                      clockwise: false)
        path.addLine(to: CGPoint(x: param.popRect.maxX,
                       y: param.popRect.origin.y + param.cornorRadius))
        let topRightArcCenter = CGPoint(x: param.popRect.maxX - param.cornorRadius,
                              y: param.popRect.origin.y + param.cornorRadius)
        path.addArc(withCenter: topRightArcCenter,
                          radius: param.cornorRadius,
                          startAngle: 0,
                          endAngle: .pi * 3 / 2, clockwise: false)
        path.addLine(to: CGPoint(x: param.arrowPosition.x + param.arrorwSize.width * 0.5,
                       y: param.popRect.origin.y))
        path.addLine(to: param.arrowPosition)
        return path
    }

    fileprivate static func leftArrowPath(_ param: TipPopParam) -> UIBezierPath {
       let path = UIBezierPath()
       guard param.direction.rawValue == ArrowDirection.left.rawValue else {
          return path
       }
       path.move(to: param.arrowPosition)
       path.addLine(to: CGPoint(x: param.popRect.origin.x,
                               y: param.arrowPosition.y + param.arrorwSize.height * 0.5))
       path.addLine(to: CGPoint(x: param.popRect.origin.x,
                               y: param.popRect.maxY - param.cornorRadius))
       let bottomLeftArcCenter = CGPoint(x: param.popRect.origin.x + param.cornorRadius,
                                         y: param.popRect.maxY - param.cornorRadius)
       path.addArc(withCenter: bottomLeftArcCenter,
                  radius: param.cornorRadius,
                  startAngle: .pi,
                  endAngle: .pi / 2,
                  clockwise: false)
       path.addLine(to: CGPoint(x: param.popRect.maxX - param.cornorRadius,
                               y: param.popRect.maxY))
       let bottomRightCenter = CGPoint(x: param.popRect.maxX - param.cornorRadius,
                                      y: param.popRect.maxY - param.cornorRadius)
       path.addArc(withCenter: bottomRightCenter,
                  radius: param.cornorRadius,
                  startAngle: .pi / 2,
                  endAngle: 0,
                  clockwise: false)
       path.addLine(to: CGPoint(x: param.popRect.maxX,
                               y: param.popRect.origin.y + param.cornorRadius))
       let topRightArcCenter = CGPoint(x: param.popRect.maxX - param.cornorRadius,
                                      y: param.popRect.origin.y + param.cornorRadius)
       path.addArc(withCenter: topRightArcCenter,
                  radius: param.cornorRadius,
                  startAngle: 0,
                  endAngle: .pi * 3 / 2,
                  clockwise: false)
       path.addLine(to: CGPoint(x: param.popRect.origin.x + param.cornorRadius,
                               y: param.popRect.origin.y))
       let topLeftArcCenter = CGPoint(x: param.popRect.origin.x + param.cornorRadius,
                                     y: param.popRect.origin.y + param.cornorRadius)
       path.addArc(withCenter: topLeftArcCenter,
                  radius: param.cornorRadius,
                  startAngle: .pi * 3 / 2,
                  endAngle: .pi,
                  clockwise: false)
       path.addLine(to: CGPoint(x: param.popRect.origin.x, y: param.arrowPosition.y - param.arrorwSize.height * 0.5))
       path.addLine(to: param.arrowPosition)
       return path
    }

    fileprivate static func bottomArrowPath(_ param: TipPopParam) -> UIBezierPath {
       let path = UIBezierPath()
       guard param.direction.rawValue == ArrowDirection.bottom.rawValue else {
           return path
       }
       path.move(to: param.arrowPosition)
       path.addLine(to: CGPoint(x: param.arrowPosition.x + param.arrorwSize.width * 0.5,
                              y: param.popRect.maxY))
       path.addLine(to: CGPoint(x: param.popRect.maxX - param.cornorRadius,
                             y: param.popRect.maxY))

       let bottomRightCenter = CGPoint(x: param.popRect.maxX - param.cornorRadius,
                                    y: param.popRect.maxY - param.cornorRadius)
       path.addArc(withCenter: bottomRightCenter,
                radius: param.cornorRadius,
                startAngle: .pi / 2,
                endAngle: 0,
                clockwise: false)
       path.addLine(to: CGPoint(x: param.popRect.maxX,
                             y: param.popRect.origin.y + param.cornorRadius))
       let topRightArcCenter = CGPoint(x: param.popRect.maxX - param.cornorRadius,
                                    y: param.popRect.origin.y + param.cornorRadius)
       path.addArc(withCenter: topRightArcCenter,
                radius: param.cornorRadius,
                startAngle: 0,
                endAngle: .pi * 3 / 2,
                clockwise: false)
       path.addLine(to: CGPoint(x: param.popRect.origin.x + param.cornorRadius,
                             y: param.popRect.origin.y))
       let topLeftArcCenter = CGPoint(x: param.popRect.origin.x + param.cornorRadius,
                                   y: param.popRect.origin.y + param.cornorRadius)
       path.addArc(withCenter: topLeftArcCenter,
                radius: param.cornorRadius,
                startAngle: .pi * 3 / 2,
                endAngle: .pi,
                clockwise: false)
       path.addLine(to: CGPoint(x: param.popRect.origin.x,
                                y: param.arrowPosition.y - param.arrorwSize.height - param.cornorRadius))

       let bottomLeftArcCenter = CGPoint(x: param.popRect.origin.x + param.cornorRadius,
                                       y: param.popRect.maxY - param.cornorRadius)
       path.addArc(withCenter: bottomLeftArcCenter,
                radius: param.cornorRadius,
                startAngle: .pi,
                endAngle: .pi / 2,
                clockwise: false)
       path.addLine(to: CGPoint(x: param.arrowPosition.x - param.arrorwSize.width * 0.5,
                             y: param.popRect.maxY))
       path.addLine(to: param.arrowPosition)
       return path
    }

    fileprivate static func rightArrowPath(_ param: TipPopParam) -> UIBezierPath {
       let path = UIBezierPath()
       guard param.direction.rawValue == ArrowDirection.right.rawValue else {
           return path
       }
       path.move(to: param.arrowPosition)
       path.addLine(to: CGPoint(x: param.popRect.maxX,
                           y: param.arrowPosition.y - param.arrorwSize.height * 0.5))

       path.addLine(to: CGPoint(x: param.popRect.maxX,
                         y: param.popRect.origin.y + param.cornorRadius))
       let topRightArcCenter = CGPoint(x: param.popRect.maxX - param.cornorRadius,
                                y: param.popRect.origin.y + param.cornorRadius)
       path.addArc(withCenter: topRightArcCenter,
            radius: param.cornorRadius,
            startAngle: 0,
            endAngle: .pi * 3 / 2,
            clockwise: false)
       path.addLine(to: CGPoint(x: param.popRect.origin.x + param.cornorRadius,
                         y: param.popRect.origin.y))
       let topLeftArcCenter = CGPoint(x: param.popRect.origin.x + param.cornorRadius,
                               y: param.popRect.origin.y + param.cornorRadius)
       path.addArc(withCenter: topLeftArcCenter,
                radius: param.cornorRadius,
                startAngle: .pi * 3 / 2,
                endAngle: .pi,
                clockwise: false)
       path.addLine(to: CGPoint(x: param.popRect.origin.x, y: param.arrowPosition.y - param.arrorwSize.height * 0.5))

       let bottomLeftArcCenter = CGPoint(x: param.popRect.origin.x + param.cornorRadius,
                                   y: param.popRect.maxY - param.cornorRadius)
       path.addArc(withCenter: bottomLeftArcCenter,
            radius: param.cornorRadius,
            startAngle: .pi,
            endAngle: .pi / 2,
            clockwise: false)

       path.addLine(to: CGPoint(x: param.popRect.maxX - param.cornorRadius,
                         y: param.popRect.maxY))
       let bottomRightCenter = CGPoint(x: param.popRect.maxX - param.cornorRadius,
                                y: param.popRect.maxY - param.cornorRadius)
       path.addArc(withCenter: bottomRightCenter,
            radius: param.cornorRadius,
            startAngle: .pi / 2,
            endAngle: 0,
            clockwise: false)

       path.addLine(to: CGPoint(x: param.popRect.maxX,
                           y: param.arrowPosition.y + param.arrorwSize.height * 0.5))

       path.addLine(to: param.arrowPosition)
       return path
    }

}
