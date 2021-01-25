//
//  IFFreeChanceSuccessAlert.swift
//  AnimationDemo
//
//  Created by lieon on 2021/1/25.
//  Copyright © 2021 lieon. All rights reserved.
//

import Foundation

class IFFreeChanceSuccessAlert: FXViewAlertBase {
    fileprivate lazy var topIcon: UIImageView = {
        let topIcon = UIImageView()
        topIcon.image = UIImage(named: "ic_save_success_top")
        return topIcon
    }()
    fileprivate lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "ic_success_save_close"), for: .normal)
        return closeBtn
    }()
    fileprivate lazy var dot0: UIView = {
        let dot0 = UIView()
        dot0.backgroundColor = UIColor(hex: 0xe5c9b6)
        dot0.layer.cornerRadius = 3
        return dot0
    }()
    fileprivate lazy var dot1: UIView = {
        let dot0 = UIView()
        dot0.backgroundColor = UIColor(hex: 0xe5c9b6)
        dot0.layer.cornerRadius = 3
        return dot0
    }()
    fileprivate lazy var descLabel0: UILabel = {
        let label = UILabel()
        label.text = "今日免费保存次数剩余0".localized(nil)
        label.font = UIFont(name: "PingFangSC-Regular", size: 15)
        label.textColor = UIColor(hex: 0x333333)
        return label
    }()
    fileprivate lazy var descLabel1: UILabel = {
        let label = UILabel()
        let totalText = "明日将会获得1次免费次数".localized(nil)
        let text0 = "明日将会获得".localized(nil)
        let text1 = "1次免费次数".localized(nil)
        if let range0 = totalText.range(of: text0),
           let range1 = totalText.range(of: text1) {
            var arrText = NSMutableAttributedString(string: totalText)
            arrText.addAttributes([NSAttributedString.Key.font : UIFont(name: "PingFangSC-Regular", size: 15)!, .foregroundColor: UIColor(hex: 0x333333)!], range:  NSRange(range0, in: totalText))
            arrText.addAttributes([NSAttributedString.Key.font : UIFont(name: "PingFangSC-Semibold", size: 15)!,
                                   .foregroundColor: UIColor(hex: 0xb48a6e)!], range:  NSRange(range1, in: totalText))
            label.attributedText = arrText
        }
        return label
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "照片保存成功".localized(nil)
        label.font = UIFont(name: "PingFangSC-Medium", size: 19)
        label.textColor = UIColor(hex: 0x333333)
        return label
    }()
    fileprivate lazy var titleBg: UIImageView = {
        let titleBg = UIImageView()
        titleBg.image = UIImage(named: "ic_success_save_title_bg")
        return titleBg
    }()
    fileprivate lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "您本次共使用13项VIP功能".localized(nil)
        label.font = UIFont(name: "PingFangSC-Regular", size: 15)
        label.textColor = UIColor(hex: 0x999999)
        return label
    }()
    
    fileprivate lazy var enterBtn: IFButton = {
        let btn = IFButton(fontSize: 16)
        btn.setTitle("好的".localized(nil), for: .normal)
        return btn
    }()
    fileprivate lazy var insetView: UIView = {
        let insetView = UIView()
        insetView.backgroundColor = .clear
        return insetView
    }()
    fileprivate lazy var containerView: UIView = {
        let insetView = UIView()
        insetView.backgroundColor = .white
        insetView.layer.cornerRadius = 2
        insetView.layer.masksToBounds = true
        return insetView
    }()
    
    /// 设置使用vip功能的个数
    func config(_ vipNums: Int) {
        let subStr = String(format: "您本次共使用%d项VIP功能".localized(nil), vipNums)
        subtitleLabel.text = subStr
    }
    
    override func setupUI() {
        super.setupUI()        
        closeBtn.addTarget(self, action: #selector(self.enterAction), for: .touchUpInside)
        enterBtn.addTarget(self, action: #selector(self.enterAction), for: .touchUpInside)
        widthAlert = UIScreen.main.bounds.width
        viewAlertBg.backgroundColor = .clear
        viewAlertBg.addSubview(insetView)
        // 用insetView把viewAlertBg撑满，防止出现分割线，至于为什么会出现分割线，没找到原因
        insetView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(UIScreen.main.bounds.size)
            $0.edges.equalToSuperview()
        }
        viewAlertBg.addSubview(containerView)
        containerView.addSubview(closeBtn)
        viewAlertBg.addSubview(topIcon)
        containerView.addSubview(closeBtn)
        containerView.addSubview(titleBg)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(enterBtn)
        containerView.addSubview(dot0)
        containerView.addSubview(dot1)
        containerView.addSubview(descLabel0)
        containerView.addSubview(descLabel1)
        
        containerView.snp.makeConstraints {
            $0.width.equalTo(290)
            $0.center.equalToSuperview()
        }
        closeBtn.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.right.equalTo(-10)
            $0.top.equalTo(10)
        }
        titleBg.snp.makeConstraints {
            $0.top.equalTo(55)
            $0.size.equalTo(CGSize(width: 175, height: 40))
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(titleBg.snp.top).offset(8)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titleBg.snp.bottom).offset(-13)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleBg.snp.bottom).offset(1)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(15)
        }
        dot0.snp.makeConstraints {
            $0.centerY.equalTo(descLabel0.snp.centerY)
            $0.right.equalTo(descLabel0.snp.left).offset(-9)
            $0.size.equalTo(CGSize(width: 6, height: 6))
        }
        descLabel0.snp.makeConstraints {
            $0.height.equalTo(15)
            $0.left.equalTo(66)
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(48)
        }
        
        dot1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 6, height: 6))
            $0.centerY.equalTo(descLabel1.snp.centerY)
            $0.right.equalTo(dot0.snp.right)
        }
        descLabel1.snp.makeConstraints {
            $0.height.equalTo(15)
            $0.top.equalTo(descLabel0.snp.bottom).offset(16)
            $0.left.equalTo(descLabel0.snp.left)
        }
        
        enterBtn.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 240, height: 50))
            $0.bottom.equalTo(-25)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descLabel1.snp.bottom).offset(44)
        }
        topIcon.snp.makeConstraints {
            $0.centerY.equalTo(containerView.snp.top).offset(-10)
            $0.size.equalTo(CGSize(width: 102, height: 102))
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc
    fileprivate func covertapAction() {
        dismiss(false)
    }
    
    @objc
    fileprivate func enterAction() {
        dismiss(true)
    }
}
