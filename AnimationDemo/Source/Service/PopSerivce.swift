//
//  PopSerivce.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/24.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

class PopSerivce {
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
    static func caculatePopRect(with pathParam: TipPopParam) -> CGRect {
       let popSize = pathParam.popSize
       let arrowPosition = pathParam.arrowPosition
       let arrowSize = pathParam.arrorwSize
       switch pathParam.direction {
       case .top:
           let popRect = CGRect(x: arrowPosition!.x - popSize!.width * 0.5,
                                y: arrowPosition!.y + pathParam.arrorwSize.height,
                                width: popSize!.width,
                                height: popSize!.height)
           return adjustOutsideFrame(popRect, minInset: pathParam.minInset)
       case .left:
           let popRect = CGRect(x: arrowPosition!.x + arrowSize!.width,
                                y: arrowPosition!.y - popSize!.height * 0.5,
                                          width: popSize!.width,
                                          height: popSize!.height)
           return adjustOutsideFrame(popRect, minInset: pathParam.minInset)
       case .bottom:
           let popRect = CGRect(x: arrowPosition!.x - popSize!.width * 0.5,
                                y: arrowPosition!.y - popSize!.height - arrowSize!.height,
                                                    width: popSize!.width,
                                                    height: popSize!.height)
           return adjustOutsideFrame(popRect, minInset: pathParam.minInset)
       case .right:
           let popRect = CGRect(x: arrowPosition!.x - arrowSize!.width - popSize!.width,
                                y: arrowPosition!.y - popSize!.height * 0.5,
                                                  width: popSize!.width,
                                                  height: popSize!.height)
         return adjustOutsideFrame(popRect, minInset: pathParam.minInset)
       default:
           return .zero
       }

    }

    static func adjustOutsideFrame(_ popRect: CGRect, minInset: CGFloat) -> CGRect {
       var popRect = popRect
       let vFrame = validFrame(UIApplication.shared.keyWindow!, minInset: minInset)
       if !vFrame.contains(popRect) {
           if popRect.origin.x < vFrame.origin.x { // 左边超出边界
             popRect.origin.x = vFrame.origin.x
         }
         if popRect.origin.y < vFrame.origin.y { // 顶部超出边界
             popRect.origin.y = vFrame.origin.y
         }
         if popRect.maxX > vFrame.maxX { // 右边超出边界
             popRect.origin.x = vFrame.maxX - popRect.width
         }
         if popRect.maxY > vFrame.maxY { // 底部超出边界
             popRect.origin.y = vFrame.maxY - popRect.height
         }
       }
       return popRect
    }

    static func adjustOutsidePoint(_ point: CGPoint,
                                   relyView: UIView = UIApplication.shared.keyWindow!,
                                   minInset: CGFloat) -> CGPoint {
       var point = point
       let vFrame = validFrame(relyView, minInset: minInset)
       if !vFrame.contains(point) {
           if point.x < vFrame.origin.x { // 左边超出边界
               point.x = vFrame.origin.x
           }
           if point.y < vFrame.origin.y { // 顶部超出边界
               point.y = vFrame.origin.y
           }
           if point.x > vFrame.maxX { // 右边超出边界
               point.x = vFrame.maxX
           }
           if point.y > vFrame.maxY { // 底部超出边界
               point.y = vFrame.maxY
           }
       }
       return point
    }

    static func validFrame(_ relyView: UIView, minInset: CGFloat) -> CGRect {
       return relyView.frame.inset(by: UIEdgeInsets(top: minInset,
                                                    left: minInset,
                                                    bottom: minInset,
                                                    right: minInset))
    }

    static func popRealFrame(with param: TipPopParam) -> CGRect {
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
    */
    static func checkArrowValid(_ pathParam: TipPopParam) -> TipPopParam {
       var pathParam = pathParam
       let arrowPosition = pathParam.arrowPosition!
       let arrowSize = pathParam.arrorwSize!
       var popRect = pathParam.popRect!
       let noCornorPopRect = noCornerPopRect(pathParam)
       switch pathParam.direction {
       case .top:
           /// 如果包含，则向调整相反的方向
           if popRect.contains(arrowPosition) || arrowPosition.y == popRect.maxY {
               pathParam.direction = .bottom
               popRect.origin = CGPoint(x: arrowPosition.x - popRect.width * 0.5,
                                        y: arrowPosition.y - popRect.height - arrowSize.height)
           }
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
           if popRect.contains(arrowPosition) || arrowPosition.x == popRect.maxX {
               pathParam.direction = .right
               popRect.origin = CGPoint(x: arrowPosition.x - arrowSize.width - popRect.width,
                                        y: arrowPosition.y - popRect.height * 0.5)
           }
           let arrowTopRightPoint = CGPoint(x: pathParam.arrowPosition.x + arrowSize.width,
                                            y: pathParam.arrowPosition.y - pathParam.arrorwSize.height * 0.5)
           let arrowBottomRightPoint = CGPoint(x: pathParam.arrowPosition.x + arrowSize.width,
                                               y: pathParam.arrowPosition.y + pathParam.arrorwSize.height * 0.5)
           if arrowTopRightPoint.y < noCornorPopRect.origin.y { //上边超出
               pathParam.arrowPosition.y = noCornorPopRect.origin.y  + arrowSize.height * 0.5
           }
           if arrowBottomRightPoint.y > noCornorPopRect.maxY { // 下边超出
                pathParam.arrowPosition.y = noCornorPopRect.maxY - arrowSize.height * 0.5
           }
       case .bottom:
           if popRect.contains(arrowPosition) || arrowPosition.y == popRect.origin.y {
               pathParam.direction = .top
               popRect.origin = CGPoint(x: arrowPosition.x - popRect.width * 0.5,
                                    y: arrowPosition.y + arrowSize.height)
           }
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
           if popRect.contains(arrowPosition) || arrowPosition.x == popRect.origin.x {
               pathParam.direction = .left
               popRect.origin = CGPoint(x: arrowPosition.x + arrowSize.width,
                                        y: arrowPosition.y - popRect.height * 0.5)
           }
           let arrowTopLeftPoint = CGPoint(x: pathParam.arrowPosition.x - arrowSize.width,
                                          y: pathParam.arrowPosition.y - pathParam.arrorwSize.height * 0.5)
           let arrowBottomLeftPoint = CGPoint(x: pathParam.arrowPosition.x - arrowSize.width,
                                             y: pathParam.arrowPosition.y + pathParam.arrorwSize.height * 0.5)
           if arrowTopLeftPoint.y < noCornorPopRect.origin.y { //上边超出
               pathParam.arrowPosition.y = noCornorPopRect.origin.y + arrowSize.height * 0.5
           }
           if arrowBottomLeftPoint.y > noCornorPopRect.maxY { // 下边超出
               pathParam.arrowPosition.y = noCornorPopRect.maxY - arrowSize.height * 0.5
           }
          
       default:
           break
       }
       pathParam.popRect = adjustOutsideFrame(popRect, minInset: pathParam.minInset)
       return pathParam
    }

    /// 去掉圆角的rect
    static func noCornerPopRect(_ pathParam: TipPopParam) -> CGRect {
        switch pathParam.direction {
        case .top:
            let noCornorPopRect = pathParam.popRect.inset(by: UIEdgeInsets(top: pathParam.cornorRadius,
                                                                        left: pathParam.cornorRadius,
                                                                        bottom: pathParam.cornorRadius,
                                                                        right: pathParam.cornorRadius))
            return noCornorPopRect
        case .left:
            let noCornorPopRect = pathParam.popRect.inset(by: UIEdgeInsets(top: pathParam.cornorRadius,
                                                                           left: pathParam.cornorRadius,
                                                                           bottom: pathParam.cornorRadius,
                                                                           right: pathParam.cornorRadius))
            return noCornorPopRect
        case .bottom:
            let noCornorPopRect = pathParam.popRect.inset(by: UIEdgeInsets(top: pathParam.cornorRadius,
                                                                            left: pathParam.cornorRadius,
                                                                            bottom: pathParam.cornorRadius,
                                                                            right: pathParam.cornorRadius))
            return noCornorPopRect
        case .right:
            let noCornorPopRect = pathParam.popRect.inset(by: UIEdgeInsets(top: pathParam.cornorRadius,
                                                                            left: pathParam.cornorRadius,
                                                                            bottom: pathParam.cornorRadius,
                                                                            right: pathParam.cornorRadius))
                return noCornorPopRect
        default:
            break
        }
        return .zero
    }
}


extension PopSerivce {
    static func getAnchorPoint(_ param: TipPopParam) -> CGPoint {
        var point = CGPoint(x: 0.5, y: 0.5)
        switch param.direction {
        case .top:
            point = CGPoint(x: param.arrowPosition.x / param.popRect.width, y: 0)
        case .bottom:
            point = CGPoint(x: param.arrowPosition.x / param.popRect.width, y: 1)
        case .left:
            point = CGPoint(x: 0, y: 1 - (param.popRect.height - param.arrowPosition.y) / param.popRect.height)
        case .right:
            point = CGPoint(x: 1, y: 1 - (param.popRect.height - param.arrowPosition.y) / param.popRect.height)
        default:
            break
        }
        return point
    }
    
    
    static  func checkArrowPosition(_ param: TipPopParam) -> TipPopParam {
        var param = param
        var arrowPosition = param.arrowPosition!
        let popRect = param.popRect!
        switch param.direction {
        case .top:
            if arrowPosition.y >= popRect.origin.y {
                arrowPosition.y = popRect.origin.y - param.arrorwSize.height
            }
        case .left:
            if arrowPosition.x < popRect.maxX && arrowPosition.x >= popRect.origin.x {
                arrowPosition.x = popRect.origin.x - param.arrorwSize.width
            }
        case .right:
            if arrowPosition.x > popRect.origin.x && arrowPosition.x <= popRect.maxX {
                arrowPosition.x = popRect.maxX + param.arrorwSize.width
            }
        case .bottom:
            if arrowPosition.y <= popRect.maxY {
                  arrowPosition.y = popRect.maxY + param.arrorwSize.height
              }
        default:
            break
        }
        param.arrowPosition = arrowPosition
        return param
    }
}
