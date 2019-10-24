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
        let realFrame = PopSerivce.popRealFrame(with: param)
        
        let bgView = UIView(frame: realFrame)
        bgView.backgroundColor = .red
        view.addSubview(bgView)
        var displayView = param.displayView
        if displayView == nil, let textParam = param.textParam {
            let font = textParam.font ?? UIFont.systemFont(ofSize: 13)
            textLabel.font = font
            textLabel.textColor = textParam.textColor
            textLabel.textAlignment = textParam.textAlignment
            textLabel.backgroundColor = textParam.backgroudColor
            textLabel.numberOfLines = 0
            displayView = textLabel
        }

         param.arrowPosition = bgView.convert(param.arrowPosition, from: view)
         param.popRect = bgView.convert(param.popRect, from: view)
         let pth = PathSerivce.path(with: param)
         popLayer.path = pth.cgPath
         bgView.layer.addSublayer(popLayer)
    
        let noCornerPopRect = PopSerivce.noCornerPopRect(param)
        displayView!.frame = noCornerPopRect
        bgView.addSubview(displayView!)
        
        if let text = param.textParam?.text, let textParam =  param.textParam {
           let spacingText = text.withlineSpacing(textParam.lineSpacing)
           textLabel.attributedText = spacingText.0
        }
    }
    
  
}
