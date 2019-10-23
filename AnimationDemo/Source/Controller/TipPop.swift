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
    //        param.priorityDirection = .top
    //        param.direction = .top
    //        param.arrowPosition = CGPoint(x: 90, y: 200)
    //        param.arrorwSize = CGSize(width: 20, height: 20)
    //        param.cornorRadius = 10
    //        param.popRect = CGRect(x: 50, y: 200 + 20, width: 200, height: 80)
    //        param.borderColor = UIColor.yellow
    //        param.borderWidth = 2

    //        param.priorityDirection = .left
    //        param.direction = .left
    //        param.arrowPosition = CGPoint(x: 50, y: 250)
    //        param.arrorwSize = CGSize(width: 20, height: 20)
    //        param.cornorRadius = 10
    //        param.popRect = CGRect(x: 70, y: 200 + 20, width: 200, height: 80)
    //        param.borderColor = UIColor.yellow
    //        param.borderWidth = 2
    //
    //        param.priorityDirection = .bottom
    //        param.direction = .bottom
    //        param.arrowPosition = CGPoint(x: view.center.x, y: 250)
    //        param.arrorwSize = CGSize(width: 20, height: 20)
    //        param.cornorRadius = 10
    //        param.popRect = CGRect(x: 70, y: 160, width: 200, height: 80)
    //        param.borderColor = UIColor.yellow
    //        param.borderWidth = 2


        param.priorityDirection = self.param.arrowDirection
        param.direction =  self.param.arrowDirection
        param.arrowPosition =  self.param.point
        param.popRect = caculatePopRect(with: self.param, pathParam: param)
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
            return adjustScreenOutsideFrame(popRect)
        case .left:
            let popRect = CGRect(x: arrowPosition!.x + arrowSize!.width,
                                 y: arrowPosition!.y - popSize!.height * 0.5,
                                           width: popSize!.width,
                                           height: popSize!.height)
            return adjustScreenOutsideFrame(popRect)
        case .bottom:
            let popRect = CGRect(x: arrowPosition!.x - popSize!.width * 0.5,
                                 y: arrowPosition!.y - popSize!.height - arrowSize!.height,
                                                     width: popSize!.width,
                                                     height: popSize!.height)
            return adjustScreenOutsideFrame(popRect)
        case .right:
            let popRect = CGRect(x: arrowPosition!.x - arrowSize!.width - popSize!.width,
                                 y: arrowPosition!.y - popSize!.height * 0.5,
                                                   width: popSize!.width,
                                                   height: popSize!.height)
          return adjustScreenOutsideFrame(popRect)
        default:
            return .zero
        }
    
    }
    
    fileprivate func adjustScreenOutsideFrame(_ popRect: CGRect ) -> CGRect {
        var popRect = popRect
        let keyWindow = UIApplication.shared.keyWindow!
        let minInset: CGFloat = 10
        if !keyWindow.frame.contains(popRect) {
          debugPrint("=======>======>")
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
