//
//  TipPop.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/23.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class TipPop: UIViewController {
    var param: TipPopParam!
    fileprivate lazy var textLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    convenience init(_ param: TipPopParam) {
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

    static func show(_ param: TipPopParam) {
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
        popLayer.fillColor = param.fillColor.cgColor
        popLayer.strokeColor = param.borderColor.cgColor
        popLayer.lineWidth = param.borderWidth
        param.arrowPosition = PopSerivce.adjustOutsidePoint(self.param.arrowPosition, minInset: self.param.minInset)
        param.popRect = PopSerivce.caculatePopRect(with: self.param)
        self.param = PopSerivce.ckeckArrowValid(param)
        let pth = PathSerivce.path(with: param)
        popLayer.path = pth.cgPath
        view.layer.addSublayer(popLayer)
        var displayView = param.displayView
        if displayView == nil {
            textLabel.font = param.textParam?.font ?? UIFont.systemFont(ofSize: 13)
            textLabel.textColor = param.textParam?.textColor ?? UIColor.black
            textLabel.textAlignment = param.textParam?.textAlignment ?? .center
            textLabel.backgroundColor = param.textParam?.backgroudColor ?? .clear
            textLabel.numberOfLines = 0
            textLabel.text = param.textParam?.text
            displayView = textLabel
        }
        displayView!.frame = PopSerivce.noCornerPopRect(param)
        view.addSubview(displayView!)
    }
  
}
