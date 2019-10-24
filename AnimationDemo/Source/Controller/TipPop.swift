//
//  TipPop.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/23.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class TipPop: UIView, AnimationBase {
    var param: TipPopParam!
    fileprivate lazy var bgView: UIView = UIView()
    fileprivate lazy var textLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    convenience init(_ param: TipPopParam, frame: CGRect) {
        self.init(frame: frame)
        self.param = param
        configUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }

    @discardableResult
    static func show(_ param: TipPopParam) -> TipPop {
        let keyWindow = UIApplication.shared.keyWindow!
        let pop = TipPop(param, frame: keyWindow.bounds)
        keyWindow.addSubview(pop)
        return pop
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0, y: 0)
        })
        delay(seconds: 0.25) {
             self.removeFromSuperview()
        }
    }

    fileprivate func configUI() {
        let popLayer = CAShapeLayer()
        popLayer.fillColor = param.fillColor.cgColor
        popLayer.strokeColor = param.borderColor.cgColor
        popLayer.lineWidth = param.borderWidth
        if let text = param.textParam?.text, let textParam = param.textParam {
            let spacingText = text.withlineSpacing(textParam.lineSpacing)
            let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: textParam.font!,
                                                              NSAttributedString.Key.paragraphStyle: spacingText.1]
            switch textParam.sizeLimitType {
            case .width(let value):
              let height = text.height(attributes: attributes, width: value)
              param.popSize = CGSize(width: value, height: height)
            case .height(let value):
              let width = text.width(attributes: attributes, height: value)
              param.popSize = CGSize(width: width, height: value)
            default:
              break
            }
        }
        param.arrowPosition = PopSerivce.adjustOutsidePoint(self.param.arrowPosition, minInset: self.param.minInset)
        param.popRect = PopSerivce.caculatePopRect(with: self.param)
        self.param = PopSerivce.ckeckArrowValid(param)
        let realFrame = PopSerivce.popRealFrame(with: param)
        bgView.frame = realFrame
        bgView.backgroundColor = .clear
        addSubview(bgView)
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
        param.arrowPosition = convert(param.arrowPosition, to: bgView)
        param.popRect = convert(param.popRect, to: bgView)
        let pth = PathSerivce.path(with: param)
        popLayer.path = pth.cgPath
        bgView.layer.addSublayer(popLayer)
        if displayView != nil {
            let noCornerPopRect = PopSerivce.noCornerPopRect(param)
            displayView!.frame = noCornerPopRect
            bgView.addSubview(displayView!)
        }
        if let text = param.textParam?.text, let textParam = param.textParam {
           let spacingText = text.withlineSpacing(textParam.lineSpacing)
           textLabel.attributedText = spacingText.0
        }
        let anchorPoint = PopSerivce.getAnchorPoint(param)
        bgView.layer.anchorPoint = anchorPoint
        bgView.frame.origin.x = bgView.layer.position.x - 0.5 * bgView.bounds.width
        bgView.frame.origin.y = bgView.layer.position.y - 0.5 * bgView.bounds.height
        bgView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.25) {
            self.bgView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
}
