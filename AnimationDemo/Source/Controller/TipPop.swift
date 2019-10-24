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
        keyWindow.frame.inset(by: UIEdgeInsets(top: param.minInset,
                                               left: param.minInset,
                                               bottom: param.minInset,
                                               right: param.minInset))
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
        param.direction = self.param.arrowDirection
        param.arrowPosition = PopSerivce.adjustOutsidePoint(self.param.point, minInset: self.param.minInset)
        param.popRect = PopSerivce.caculatePopRect(with: self.param, pathParam: param)
        param = PopSerivce.ckeckArrowValid(param)
        let pth = PathSerivce.path(with: param)
        popLayer.path = pth.cgPath
        view.layer.addSublayer(popLayer)
    }
  
}
