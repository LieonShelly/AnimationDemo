//
//  IFRecommendStartBtnPop.swift
//  AnimationDemo
//
//  Created by lieon on 2020/7/10.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class IFRecommendStartBtnPop: UIView {
    struct UISize {
        static let arrowH: CGFloat = 6
        static let lineW: CGFloat = 0.8
    }
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "点击获取灵感~"
        label.textAlignment = .center
        label.textColor = UIColor(hex: 0x808080)
        label.font = UIFont.customFont(ofSize: 13)
        return label
    }()
    
    fileprivate lazy var containerView: IFGradientView = {
        let view = IFGradientView()
        view.clipsToBounds = false
        let gradientLayer =  view.layer as? CAGradientLayer
        gradientLayer?.colors = [
            UIColor(hex: 0xff64b9)!.cgColor,
            UIColor(hex: 0x927cff)!.cgColor
        ]
        gradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer?.endPoint = CGPoint(x: 1, y: 0.5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        addSubview(containerView)
        addSubview(titleLabel)
        containerView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(13)
            $0.left.equalTo(5)
            $0.right.equalTo(-5)
            $0.centerY.equalToSuperview().offset(-UISize.arrowH * 0.5)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.gradientTitle([UIColor(hex: 0xff64b9)!.cgColor,
                                   UIColor(hex: 0x927cff)!.cgColor,
            ],
                                 locations: [0.3, 0.7])
    }
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let path = UIBezierPath()
        let lineW = UISize.lineW
        let radius = (bounds.height - UISize.arrowH - lineW) * 0.5
        path.move(to: CGPoint(x: radius + lineW * 0.5, y: lineW * 0.5))
        path.addLine(to: CGPoint(x: bounds.width - radius - lineW * 0.5, y: lineW * 0.5))
        path.addArc(withCenter: CGPoint(x: bounds.width - radius - lineW * 0.5, y: radius + lineW * 0.5), radius: radius, startAngle: CGFloat.pi * 3 / 2, endAngle: .pi / 2, clockwise: true)
        let arrw: CGFloat = 6
        path.addLine(to: CGPoint(x: bounds.width * 0.5 + arrw * 0.5, y: bounds.height - UISize.arrowH))
        path.addLine(to: CGPoint(x: bounds.width * 0.5, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width * 0.5 - arrw * 0.5, y: bounds.height - UISize.arrowH))
        path.addLine(to: CGPoint(x: radius + lineW * 0.5, y: bounds.height - UISize.arrowH - lineW * 0.5))
        path.addArc(withCenter: CGPoint(x: radius + lineW * 0.5, y: radius + lineW * 0.5), radius: radius, startAngle: .pi / 2, endAngle: .pi * 3 / 2, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.borderColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineW
        shapeLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        
        containerView.layer.mask = shapeLayer
        

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}


public extension UILabel {
    /// 文字颜色渐变
    func gradientTitle(_ colors: [CGColor], locations: [CGFloat]) {
        layoutIfNeeded()
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        let colorSpaceRef: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let gradientColors = colors as CFArray
        let labContext = UIGraphicsGetCurrentContext()
        if let context = labContext,
            let gradientRef: CGGradient = CGGradient(colorsSpace: colorSpaceRef, colors: gradientColors, locations: locations) {
            let startPoint = CGPoint.zero
            let endPoint = CGPoint(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y + bounds.size.height)
            context.drawLinearGradient(gradientRef, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
            let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
            if gradientImage != nil {
                textColor = UIColor(patternImage: gradientImage!)
            }
        }
    }
}
