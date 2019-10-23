//
//  TipPop.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/23.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit


class TipPop: UIViewController {
    var param: TipPopInputParam!
    
    convenience init(_ param: TipPopInputParam) {
        self.init()
        self.param = param
    }
    
    override func viewDidLoad() {
          super.viewDidLoad()
          configUI()
      }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeFromParent()
        view.removeFromSuperview()
    }

    static func show(_ param: TipPopInputParam) {
        let pop = TipPop(param)
        let keyWindow = UIApplication.shared.keyWindow!
        pop.view.frame = UIApplication.shared.keyWindow!.bounds
        keyWindow.rootViewController!.addChild(pop)
        keyWindow.addSubview(pop.view)
    }

    fileprivate func configUI() {
        let popLayer = CAShapeLayer()
        popLayer.fillColor = UIColor.yellow.cgColor
        popLayer.strokeColor = UIColor.clear.cgColor
        var param = CommonTipPopParam()
        param.minInset = self.param.minInset
        param.priorityDirection = self.param.arrowDirection
        param.direction =  self.param.arrowDirection
        param.arrowPosition =  self.param.point
        param.popRect = caculatePopRect(with: self.param, pathParam: param)
        param = ckeckArrowValid(param)
        let pth = PathHelper.path(with: param)
        popLayer.path = pth.cgPath
        view.layer.addSublayer(popLayer)
    }
   /**
        1.根据箭头方向计算出出realFrame
        2.判断realFrame是否超出屏幕
        2.1如果没有超出，直接绘制路径
        2.2如果超出，根据方向计算出最小位置的realFrame
        2.3判断最小位置的realFrame是否包含arrowPosition
        2.3.1如果包含直接跳出，绘制路径
        2.3.2如果不包含
        
        1. 箭头在顶部时，箭头的rect的x必须在poprect内（除去圆角半径）
        */
    
    fileprivate func caculatePopRect(with inputParam: TipPopInputParam,
                                     pathParam: TipPopParam) -> CGRect {
        let popSize = inputParam.popSize
        let arrowPosition = inputParam.point
        let arrowSize = pathParam.arrorwSize
        switch inputParam.arrowDirection {
        case .top:
            /// 1.优先以arrowPosition为中心点
            let popRect = CGRect(x: arrowPosition!.x - popSize!.width * 0.5,
                                 y: arrowPosition!.y + pathParam.arrorwSize.height,
                                 width: popSize!.width,
                                 height: popSize!.height)
            return adjustScreenOutsideFrame(popRect, minInset: param.minInset)
        case .left:
            let popRect = CGRect(x: arrowPosition!.x + arrowSize!.width,
                                 y: arrowPosition!.y - popSize!.height * 0.5,
                                           width: popSize!.width,
                                           height: popSize!.height)
            return adjustScreenOutsideFrame(popRect, minInset: pathParam.minInset)
        case .bottom:
            let popRect = CGRect(x: arrowPosition!.x - popSize!.width * 0.5,
                                 y: arrowPosition!.y - popSize!.height - arrowSize!.height,
                                                     width: popSize!.width,
                                                     height: popSize!.height)
            return adjustScreenOutsideFrame(popRect, minInset: param.minInset)
        case .right:
            let popRect = CGRect(x: arrowPosition!.x - arrowSize!.width - popSize!.width,
                                 y: arrowPosition!.y - popSize!.height * 0.5,
                                                   width: popSize!.width,
                                                   height: popSize!.height)
          return adjustScreenOutsideFrame(popRect, minInset: param.minInset)
        default:
            return .zero
        }
    
    }
    
    fileprivate func adjustScreenOutsideFrame(_ popRect: CGRect, minInset: CGFloat) -> CGRect {
        var popRect = popRect
        let keyWindow = UIApplication.shared.keyWindow!
        if !keyWindow.frame.contains(popRect) {
          if popRect.origin.x < 0 { // 左边超出边界
              popRect.origin.x = minInset
          }
          if popRect.origin.y < 0 { // 顶部超出边界
              popRect.origin.y = minInset
          }
          if popRect.maxX > keyWindow.frame.maxX { // 右边超出边界
              popRect.origin.x = keyWindow.frame.maxX - minInset - popRect.width
          }
          if popRect.maxY > keyWindow.bounds.maxY { // 底部超出边界
              popRect.origin.y = keyWindow.frame.maxY - minInset - popRect.height
          }
        }
        return popRect
    }
    
    
    fileprivate func popRealFrame(with param: TipPopParam) -> CGRect {
       
       switch param.direction {
       case .top:
           let realFrame = CGRect(x: param.popRect.origin.x,
                                  y: param.popRect.origin.y - param.arrorwSize.height,
                                  width: param.popRect.width,
                                  height: param.popRect.height + param.arrorwSize.height)
           return realFrame
       case .left:
           let realFrame = CGRect(x: param.arrowPosition.x,
                                   y: param.popRect.origin.y,
                                   width: param.popRect.width + param.arrorwSize.width,
                                   height: param.popRect.height)
           return realFrame
       case .bottom:
           let realFrame = CGRect(x: param.popRect.origin.x,
                                  y: param.popRect.origin.y,
                                  width: param.popRect.width,
                                  height: param.popRect.height + param.arrorwSize.height)
           return realFrame
       case .right:
            let realFrame = CGRect(x: param.popRect.origin.x,
                                     y: param.popRect.origin.y,
                                     width: param.popRect.width + param.arrorwSize.width,
                                     height: param.popRect.height)
           return realFrame
       default:
           break
       }
       
       return .zero
    }

    /**
     校验气泡的有效性（箭头的位置不能动）：
     1.箭头是否在poprect之外
     2.箭头的位置是否在有效边上
     如果不满足，则调整poprect的位置,
     */
    fileprivate func ckeckArrowValid<T: TipPopParam>(_ pathParam: T) -> T {
        var pathParam = pathParam
        let arrowPosition = pathParam.arrowPosition!
        let arrowSize = pathParam.arrorwSize!
        var popRect = pathParam.popRect!
        switch pathParam.direction {
        case .top:
            /// 如果包含，则向调整相反的方向
            if popRect.contains(arrowPosition) {
                pathParam.direction = .bottom
                popRect.origin = CGPoint(x: arrowPosition.x - popRect.width * 0.5,
                                         y: arrowPosition.y - popRect.height - arrowSize.height)
            }
            /// 判断三角形的x是否超出没有圆角的rect
            let noCornorPopRect = CGRect(x: popRect.origin.x + pathParam.cornorRadius,
                                         y: popRect.origin.y,
                                         width: popRect.width - pathParam.cornorRadius * 2,
                                         height: pathParam.popRect.height)
            let arrowBottomLeftPoint = CGPoint(x: pathParam.arrowPosition.x - pathParam.arrorwSize.width * 0.5,
                                               y: pathParam.popRect.origin.y)
            if arrowBottomLeftPoint.x < noCornorPopRect.origin.x { //左边超出
                pathParam.arrowPosition.x = noCornorPopRect.origin.x + pathParam.arrorwSize.width * 0.5
            }
            let arrowBottomRightPoint = CGPoint(x: pathParam.arrowPosition.x + pathParam.arrorwSize.width * 0.5,
                                                y: noCornorPopRect.origin.y)
            if arrowBottomRightPoint.x > noCornorPopRect.maxX { // 右边超出
                pathParam.arrowPosition.x = noCornorPopRect.maxX - pathParam.arrorwSize.width * 0.5
            }
        case .left:
            if popRect.contains(arrowPosition) {
                pathParam.direction = .right
                popRect.origin = CGPoint(x: arrowPosition.x - arrowSize.width - popRect.width,
                                         y: arrowPosition.y - popRect.height * 0.5)
            }
            let noCornorPopRect = CGRect(x: pathParam.popRect.origin.x,
                                         y: pathParam.popRect.origin.y + pathParam.cornorRadius,
                                         width: pathParam.popRect.width,
                                         height: pathParam.popRect.height - 2 * pathParam.cornorRadius * 2)
            let arrowTopRightPoint = CGPoint(x: pathParam.arrowPosition.x + arrowSize.width,
                                             y: pathParam.arrowPosition.y - pathParam.arrorwSize.height * 0.5)
            let arrowBottomRightPoint = CGPoint(x: pathParam.arrowPosition.x + arrowSize.width,
                                                y: pathParam.arrowPosition.y + pathParam.arrorwSize.height * 0.5)
            if arrowTopRightPoint.y < noCornorPopRect.origin.y { //上边超出
                pathParam.arrowPosition.y = noCornorPopRect.origin.y
            }
            if arrowBottomRightPoint.y > noCornorPopRect.maxY { // 下边超出
                pathParam.arrowPosition.y = noCornorPopRect.maxY
            }
        case .bottom:
            if popRect.contains(arrowPosition) {
                pathParam.direction = .top
                popRect.origin = CGPoint(x: arrowPosition.x - popRect.width * 0.5,
                                     y: arrowPosition.y + arrowSize.height)
            }
            let noCornorPopRect = CGRect(x: popRect.origin.x + pathParam.cornorRadius,
                                               y: popRect.origin.y,
                                               width: popRect.width - pathParam.cornorRadius * 2,
                                               height: pathParam.popRect.height)
            let arrowTopLeftPoint = CGPoint(x: pathParam.arrowPosition.x - pathParam.arrorwSize.width * 0.5,
                                            y: pathParam.popRect.maxY + pathParam.arrorwSize.height)
            if arrowTopLeftPoint.x < noCornorPopRect.origin.x { //左边超出
                pathParam.arrowPosition.x = noCornorPopRect.origin.x + pathParam.arrorwSize.width * 0.5
            }
            let arrowTopRightPoint = CGPoint(x: pathParam.arrowPosition.x + pathParam.arrorwSize.width * 0.5,
                                              y: pathParam.popRect.maxY + pathParam.arrorwSize.height)
            if arrowTopRightPoint.x > noCornorPopRect.maxX { // 右边超出
              pathParam.arrowPosition.x = noCornorPopRect.maxX - pathParam.arrorwSize.width * 0.5
            }
        case .right:
            if popRect.contains(arrowPosition) {
                pathParam.direction = .left
                popRect.origin = CGPoint(x: arrowPosition.x + arrowSize.width,
                                         y: arrowPosition.y - popRect.height * 0.5)
            }
            let noCornorPopRect = CGRect(x: pathParam.popRect.origin.x,
                                        y: pathParam.popRect.origin.y + pathParam.cornorRadius,
                                        width: pathParam.popRect.width,
                                        height: pathParam.popRect.height - 2 * pathParam.cornorRadius * 2)
            let arrowTopLeftPoint = CGPoint(x: pathParam.arrowPosition.x - arrowSize.width,
                                           y: pathParam.arrowPosition.y - pathParam.arrorwSize.height * 0.5)
            let arrowBottomLeftPoint = CGPoint(x: pathParam.arrowPosition.x - arrowSize.width,
                                              y: pathParam.arrowPosition.y + pathParam.arrorwSize.height * 0.5)
            if arrowTopLeftPoint.y < noCornorPopRect.origin.y { //上边超出
                pathParam.arrowPosition.y = noCornorPopRect.origin.y
            }
            if arrowBottomLeftPoint.y > noCornorPopRect.maxY { // 下边超出
                pathParam.arrowPosition.y = noCornorPopRect.maxY
            }
        default:
            break
        }
        pathParam.popRect = adjustScreenOutsideFrame(popRect, minInset: param.minInset)
        return pathParam
    }
}



class PathHelper: NSObject {
    
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

    
    /**
      需要检查箭头rect的右下角和左下角是够在
     */
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
       path.addLine(to: CGPoint(x: param.popRect.origin.x, y: param.arrowPosition.y - param.arrorwSize.height * 0.5))

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
