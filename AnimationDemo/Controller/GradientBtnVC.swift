//
//  GradientBtnVC.swift
//  AnimationDemo
//
//  Created by lieon on 2020/5/15.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class GradientBtnVC: UIViewController {
    fileprivate lazy var bgView: UIImageView = {
        let bgView = UIImageView()
        bgView.image = UIImage(named: "ic_tutorial_code_bg")
        return bgView
    }()
    fileprivate lazy var titleIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "ic_tutorial_code_gift")
        return icon
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 19, isBold: true)
        label.text = "礼品卡兑换"
        label.textColor = UIColor(hex: 0x333333)
        return label
    }()
    fileprivate lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 11, isBold: false)
        label.textColor = UIColor(hex: 0x808080)
        label.text = "礼品卡无效，请检查重试"
        return label
    }()
    fileprivate lazy var inputTextfield: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "请输入礼品卡"
        textField.backgroundColor = UIColor(hex: 0xf6f6f6)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()
    
    fileprivate lazy var btn: FXCodeGradientBtn = {
        let btn = FXCodeGradientBtn()
        btn.setTitle("立即领取", for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 16, isBold: true)
        btn.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
        btn.setTitleColor(UIColor.white.withAlphaComponent(0.2), for: .disabled)
        btn.normalShadow()
        return btn
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    fileprivate func setupUI() {
        let widthAlert = 290.0.fitiPhone5sSerires
        let container = UIView()
        view.addSubview(container)
        container.addSubview(bgView)
        container.addSubview(titleIcon)
        container.addSubview(titleLabel)
        container.addSubview(tipLabel)
        container.addSubview(inputTextfield)
        container.addSubview(btn)
        
        container.snp.makeConstraints {
            $0.width.equalTo(widthAlert)
            $0.center.equalToSuperview()
        }
        
        bgView.snp.makeConstraints {
            $0.left.top.right.equalTo(0)
            $0.height.equalTo(227)
            
        }
        
        titleIcon.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 48, height: 48))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(32)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(titleIcon.snp.centerX)
            $0.top.equalTo(titleIcon.snp.bottom).offset(5)
            $0.height.equalTo(18)
        }
        tipLabel.snp.makeConstraints {
            $0.centerX.equalTo(titleLabel.snp.centerX)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.5)
            $0.height.equalTo(11)
        }
        inputTextfield.snp.makeConstraints {
            $0.top.equalTo(tipLabel.snp.bottom).offset(23.5)
            $0.height.equalTo(50)
            $0.left.equalTo(50)
            $0.right.equalTo(-50)
        }
        btn.snp.makeConstraints {
            $0.top.equalTo(inputTextfield.snp.bottom).offset(25)
            $0.height.equalTo(50)
            $0.left.equalTo(50)
            $0.right.equalTo(-50)
            $0.bottom.equalTo(-25)
        }
        
    }
}


class FXCodeGradientBtn: UIButton {
    fileprivate var needLayout: Bool = true
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 8
        gradientLayer.colors = [UIColor(hex: 0x7ad3ff)!, UIColor(hex: 0xff41d3)!].map{ $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradientLayer
    }()
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if needLayout {
            gradientLayer.bounds = bounds
            gradientLayer.opacity = 0.2
            setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .disabled)
            setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .highlighted)
            gradientLayer.opacity = 1
            setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .normal)
            needLayout = false
        }
    }
    
    /// disable时, 阴影 0.2
    func disableShadow() {
        layer.shadowOffset = CGSize.init(width: 0, height: 10)
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.2
        layer.shadowColor = UIColor(hex: 0xB196ED)?.cgColor
    }
    
    /// disable时, 阴影 0.4
    func normalShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.4
        layer.shadowColor = UIColor(hex: 0xB196ED)?.cgColor
    }
    
}



class FXManualVideoGradientBtn: UIButton {
    fileprivate var needLayout: Bool = true
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 8
        gradientLayer.colors = [UIColor(hex: 0x7ad3ff)!, UIColor(hex: 0xff41d3)!].map{ $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradientLayer
    }()
    fileprivate lazy var textLabel0: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .white
        textLabel.textAlignment = .center
        textLabel.isUserInteractionEnabled = false
        textLabel.font = UIFont.customFont(ofSize: 12)
        textLabel.text = "进阶"
        return textLabel
    }()
    fileprivate lazy var textLabel1: UILabel = {
         let textLabel = UILabel()
         textLabel.textColor = .white
         textLabel.textAlignment = .center
         textLabel.font = UIFont.customFont(ofSize: 12)
         textLabel.text = "技巧"
        textLabel.isUserInteractionEnabled = false
         return textLabel
     }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stack = UIView()
        addSubview(stack)
        stack.addSubview(textLabel0)
        stack.addSubview(textLabel1)
        stack.snp.makeConstraints {
            $0.center.equalTo(snp.center)
            $0.height.equalTo(26)
            $0.width.equalTo(24)
        }
        textLabel0.snp.makeConstraints{
            $0.top.equalTo(stack.snp.top)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(12)
        }
        textLabel1.snp.makeConstraints{
            $0.top.equalTo(textLabel0.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(12)
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if needLayout {
            gradientLayer.bounds = bounds
            gradientLayer.opacity = 0.2
            setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .disabled)
            setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .highlighted)
            gradientLayer.opacity = 1
            setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .normal)
            needLayout = false
        }
    }
    
    /// disable时, 阴影 0.2
    func disableShadow() {
        layer.shadowOffset = CGSize.init(width: 0, height: 10)
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.2
        layer.shadowColor = UIColor(hex: 0xB196ED)?.cgColor
    }
    
    /// disable时, 阴影 0.4
    func normalShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.4
        layer.shadowColor = UIColor(hex: 0xB196ED)?.cgColor
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}
