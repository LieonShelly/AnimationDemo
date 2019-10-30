//
//  TipPop.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/23.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class TipPop: UIView, AnimationBase {
    fileprivate lazy var coverBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(self.dismiss), for: .touchUpInside)
        return btn
    }()
    
    convenience init(_ param: TipPopParam, frame: CGRect) {
        self.init(frame: frame)
        configCoverBtn(param)
        configPop(param)
    }
    
    convenience init(_ params: [TipPopParam], frame: CGRect) {
        self.init(frame: frame)
        if let firstParam = params.first {
            configCoverBtn(firstParam)
        }
        params.forEach(configPop)
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
    
    @discardableResult
    static func show(_ params: [TipPopParam]) -> TipPop {
        let keyWindow = UIApplication.shared.keyWindow!
        let pop = TipPop(params, frame: keyWindow.bounds)
        keyWindow.addSubview(pop)
        return pop
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0, y: 0)
        })
        delay(seconds: 0.25) {
             self.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        debugPrint("textLabel")
    }
    
    fileprivate func configPop(_ param: TipPopParam) {
        let bgView = createBgView(param)
        if param.textParam != nil {
            configTextLabelUI(param, bgView: bgView)
        } else if let _ = param.displayView {
          configCustomUI(param, bgView: bgView)
        }
    }
    
    fileprivate func configCustomUI(_ param: TipPopParam, bgView: UIView) {
        bgView.backgroundColor = .clear
        var param = param
        if let displayView = param.displayView, displayView.frame.size != .zero {
           param.popSize = displayView.bounds.inset(by: UIEdgeInsets(top: -param.minInset,
                                                                    left: -param.minInset,
                                                                    bottom: -param.minInset,
                                                   right: -param.minInset))
                                               .size
            param.arrowPosition = PopSerivce.adjustOutsidePoint(param.arrowPosition, minInset: param.minInset)
            param.popRect = PopSerivce.caculatePopRect(with: param)
            param = PopSerivce.checkArrowValid(param)
            let realFrame = PopSerivce.popRealFrame(with: param)
            bgView.frame = realFrame
            bgView.backgroundColor = .clear
            addSubview(bgView)
            param.arrowPosition = convert(param.arrowPosition, to: bgView)
            param.popRect = convert(param.popRect, to: bgView)
            let poLayer = createPopLayer(param)
            configPopLayer(param,
                           popLayer: poLayer,
                           bgView: bgView)
            let noCornerPopRect = PopSerivce.noCornerPopRect(param)
            displayView.frame = noCornerPopRect
            bgView.addSubview(displayView)
        } else if let displayView = param.displayView {
            param.arrowPosition = PopSerivce.adjustOutsidePoint(param.arrowPosition, minInset: param.minInset)
            param.popRect = PopSerivce.caculatePopRect(with: param)
            param = PopSerivce.checkArrowValid(param)
            let realFrame = PopSerivce.popRealFrame(with: param)
            bgView.frame = realFrame
            bgView.backgroundColor = .clear
            addSubview(bgView)
            param.arrowPosition = convert(param.arrowPosition, to: bgView)
            param.popRect = convert(param.popRect, to: bgView)
            param = PopSerivce.checkArrowPosition(param)
            let poLayer = createPopLayer(param)
            configPopLayer(param,
                          popLayer: poLayer,
                          bgView: bgView)
            let noCornerPopRect = PopSerivce.noCornerPopRect(param)
            displayView.frame = noCornerPopRect
            bgView.addSubview(displayView)
        }
        showAnimation(bgView, param: param)
    }
    
    fileprivate func configTextLabelUI(_ param: TipPopParam,  bgView: UIView) {
        var param = param
        if let text = param.textParam?.text, let textParam = param.textParam {
            let atrrStr = NSMutableAttributedString(string: text)
            let paragrapStyle = NSMutableParagraphStyle()
            paragrapStyle.lineBreakMode = .byWordWrapping
            paragrapStyle.lineSpacing = textParam.lineSpacing
            atrrStr.addAttribute(NSAttributedString.Key.paragraphStyle,
                                 value: paragrapStyle,
                                 range: NSRange(location: 0, length: text.count))
            atrrStr.addAttribute(NSAttributedString.Key.font,
                                 value: textParam.font ?? UIFont.systemFont(ofSize: 13),
                                 range: NSRange(location: 0, length: text.count))
            let textLabel = UILabel()
            let font = textParam.font ?? UIFont.systemFont(ofSize: 13)
            textLabel.font = font
            textLabel.textColor = textParam.textColor
            textLabel.textAlignment = textParam.textAlignment
            textLabel.backgroundColor = textParam.backgroudColor
            textLabel.numberOfLines = 0
            textLabel.attributedText = atrrStr
            switch textParam.sizeLimitType {
            case .width(let value):
                 let size = atrrStr.boundingRect(with: CGSize(width: value, height: .infinity), options: .usesLineFragmentOrigin, context: nil).size
                 param.popSize = CGSize(width: size.width + param.minInset * 2, height: size.height + param.minInset * 2)
            case .height(let value):
                 let size = atrrStr.boundingRect(with: CGSize(width: .infinity, height: value), options: .usesLineFragmentOrigin, context: nil).size
                 param.popSize = CGSize(width: size.width + param.minInset * 2, height: size.height + param.minInset * 2)
            default:
                break
            }
            param.arrowPosition = PopSerivce.adjustOutsidePoint(param.arrowPosition, minInset: param.minInset)
            param.popRect = PopSerivce.caculatePopRect(with: param)
            param = PopSerivce.checkArrowValid(param)
            let realFrame = PopSerivce.popRealFrame(with: param)
            bgView.frame = realFrame
            bgView.backgroundColor = .clear
            addSubview(bgView)
            param.arrowPosition = convert(param.arrowPosition, to: bgView)
            param.popRect = convert(param.popRect, to: bgView)
            param = PopSerivce.checkArrowPosition(param)
            let poLayer = createPopLayer(param)
            configPopLayer(param,
                        popLayer: poLayer,
                        bgView: bgView)
            let noCornerPopRect = PopSerivce.noCornerPopRect(param)
            textLabel.frame = noCornerPopRect
            bgView.addSubview(textLabel)
        }
        showAnimation(bgView, param: param)
    }

    fileprivate func showAnimation(_ view: UIView, param: TipPopParam) {
        let bgView = view
        let anchorPoint = PopSerivce.getAnchorPoint(param)
         bgView.layer.anchorPoint = anchorPoint
         bgView.frame.origin.x = bgView.layer.position.x - 0.5 * bgView.bounds.width
         bgView.frame.origin.y = bgView.layer.position.y - 0.5 * bgView.bounds.height
         bgView.transform = CGAffineTransform(scaleX: 0, y: 0)
         UIView.animate(withDuration: 0.25) {
             bgView.transform = CGAffineTransform(scaleX: 1, y: 1)
         }
    }
    
    fileprivate func createPopLayer(_ param: TipPopParam) -> CAShapeLayer {
        let popLayer = CAShapeLayer()
        popLayer.fillColor = param.fillColor.cgColor
        popLayer.strokeColor = param.borderColor.cgColor
        popLayer.lineWidth = param.borderWidth
        return popLayer
    }
    
    fileprivate func createBgView(_ param: TipPopParam) -> UIView {
        let bgView = UIView()
        bgView.backgroundColor = .clear
        return bgView
    }
    
    fileprivate func configCoverBtn(_ param: TipPopParam) {
        coverBtn.backgroundColor = param.backgroundColor
        coverBtn.frame = bounds
        addSubview(coverBtn)
    }
    
    fileprivate func configPopLayer(_ param: TipPopParam,
                                    popLayer: CAShapeLayer,
                                    bgView: UIView) {
        let pth = PathSerivce.path(with: param)
        popLayer.path = pth.cgPath
        bgView.layer.addSublayer(popLayer)
    }
    
}

class PopLabel: UILabel {
    var param: TipPopParam!
    
    convenience init(_ param: TipPopParam) {
        self.init()
        self.param = param
    }
    
   override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
   required init?(coder: NSCoder) {
        super.init(coder: coder)

    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let rect = rect
        switch param.direction {
        case .top:
            param.popRect = rect.inset(by: UIEdgeInsets(top: param.arrorwSize.height,
                                                        left: param.arrorwSize.width,
                                                        bottom: param.arrorwSize.height,
                                                        right: param.arrorwSize.width))
        default:
            param.popRect = rect.inset(by: UIEdgeInsets(top: param.arrorwSize.height,
                                                                   left: param.arrorwSize.width,
                                                                   bottom: param.arrorwSize.height,
                                                                   right: param.arrorwSize.width))
        }
        let pth = PathSerivce.path(with: param)
        param.fillColor.setFill()
        pth.fill()
        debugPrint("PopLabel:\(rect) - bounds:\(self.bounds)) - frame: \(self.frame)")
    }
}
