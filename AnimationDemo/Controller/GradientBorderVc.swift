//
//  GradientBorderVc.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/2.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class Button: UIButton {
    
    override var titleLabel: UILabel? {
        let label = UILabel()
        return label
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        
    }
}

class GradientBorderVc: UIViewController {
    struct UISize {
        static let iconSize: CGSize = CGSize(width: 42.fitiPhone5sSerires, height: 42.fitiPhone5sSerires)
        static let lineWidth: CGFloat = 1
        static let cycleWidth: CGFloat = 52.fitiPhone5sSerires
        static let lineMaxWidth: CGFloat = 2
    }
    
    fileprivate lazy var imageView: FXManualVideoGradientBtn = {
        let imageView = FXManualVideoGradientBtn()
        imageView.gradientLayer.colors = [UIColor(hex: 0xd996fb)!.cgColor, UIColor(hex: 0xa199f5)!.cgColor]
        imageView.gradientLayer.endPoint = CGPoint(x: 1, y: 0.8)
        imageView.gradientLayer.cornerRadius = UISize.iconSize.width * 0.5
        return imageView
    }()
    fileprivate lazy var shapeLayer: CAShapeLayer = {
        let cycleLayer = CAShapeLayer()
        cycleLayer.strokeColor = UIColor(hex: 0xC47AFF)?.cgColor
        cycleLayer.lineWidth = UISize.lineWidth
        cycleLayer.fillColor = UIColor.clear.cgColor
        return cycleLayer
    }()
    fileprivate lazy var grdientLayer: CAGradientLayer = {
        let grdientLayer = CAGradientLayer()
        grdientLayer.colors = [UIColor(hex: 0xd996fb)!.cgColor, UIColor(hex: 0xa199f5)!.cgColor]
        grdientLayer.startPoint = CGPoint(x: 0, y: 0.2)
        grdientLayer.endPoint = CGPoint(x: 1, y: 0.8)
        return grdientLayer
    }()
    
    fileprivate lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2
        style.minimumLineHeight = 12
        let text = "阿萨德回房间爱但是开发阿士大夫爱但是开发阿士大夫爱但是开发阿士大夫爱但是开发阿士大夫爱但是开发阿士大夫爱但是开发阿士大夫爱但是开发阿士大夫爱但是开发阿士大夫爱但是开发阿士大夫爱但是开发阿士大夫爱但是开发阿士大夫还饥渴阿萨德接口返回"//"进阶\n技巧"
        let title = NSMutableAttributedString(string: text)
        title.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black,
                             NSAttributedString.Key.font: UIFont.customFont(ofSize: 12),
                             NSAttributedString.Key.paragraphStyle: style],
                            range: NSRange(location: 0, length: text.count))
        textLabel.numberOfLines = 0
        textLabel.attributedText = title
        return textLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.addSublayer(grdientLayer)
    
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(UISize.iconSize)
        }
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(200)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        shapeLayer.lineWidth = 1.5
        let destinationRect = CGRect(x: view.center.x - UISize.cycleWidth * 0.5, y: view.center.y - UISize.cycleWidth * 0.5, width: UISize.cycleWidth, height: UISize.cycleWidth)
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: destinationRect.height, height: destinationRect.height), cornerRadius: destinationRect.height * 0.5).cgPath
        grdientLayer.mask = shapeLayer
        grdientLayer.cornerRadius = destinationRect.height * 0.5
        grdientLayer.frame = destinationRect
    }
}
