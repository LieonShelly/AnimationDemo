//
//  IFFreeChanceAlert.swift
//  AnimationDemo
//
//  Created by lieon on 2021/1/25.
//  Copyright © 2021 lieon. All rights reserved.
//

import Foundation

class IFFreeChanceAlert: FXViewAlertBase {
    fileprivate lazy var topIcon: UIImageView = {
        let topIcon = UIImageView()
        topIcon.image = UIImage(named: "ic_free_alert_top")
        return topIcon
    }()
    fileprivate lazy var enterBtn: IFButton = {
        let btn = IFButton(fontSize: 16)
        btn.setTitle("立即领取".localized(nil), for: .normal)
        return btn
    }()
    fileprivate lazy var bgView: UIImageView = {
        let bgView = UIImageView()
        bgView.image = UIImage(named: "ic_free_alert_bg")
        return bgView
    }()
    fileprivate lazy var insetView: UIView = {
        let insetView = UIView()
        insetView.isUserInteractionEnabled = true
        return insetView
    }()
    fileprivate lazy var container: UIView = {
        let container = UIView()
        return container
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 19)
        titleLabel.text = "恭喜你获得幸运礼包".localized(nil)
        titleLabel.textColor = UIColor(hex: 0x333333)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    fileprivate lazy var titleBg: UIImageView = {
        let titleBg = UIImageView()
        titleBg.image = UIImage(named: "ic_free_alert_title_bg")
        return titleBg
    }()
    fileprivate lazy var mediumLine: UIImageView = {
        let mediumLine = UIImageView()
        mediumLine.image = UIImage(named: "ic_free_alert_title_line")
        return mediumLine
    }()
    fileprivate lazy var descLabel0: UILabel = {
        let label = UILabel()
        label.text = "每天可使用".localized(nil)
        label.font = UIFont(name: "PingFangSC-Medium", size: 14)
        label.textColor = UIColor(hex: 0xb48a6e)
        return label
    }()
    fileprivate lazy var descLabel1: UILabel = {
        let label = UILabel()
        label.text = "VIP功能免费修图1次".localized(nil)
        label.font = UIFont(name: "PingFangSC-Medium", size: 19)
        label.textColor = UIColor(hex: 0xb48a6e)
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        // 布局思路：用insetView去支撑viewAlertBg为整个屏幕
        // 这么做的原因：是为了解决viewAlertBg出现边框线的问题
        widthAlert = UIScreen.main.bounds.width
        autoDismissWhileBackgroundClicked = true
        viewAlertBg.addSubview(insetView)
        insetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.center.equalToSuperview()
            $0.size.equalTo(UIScreen.main.bounds.size)
            
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(covertapAction))
        insetView.addGestureRecognizer(tap)
        enterBtn.addTarget(self, action: #selector(self.enterAction), for: .touchUpInside)
        viewAlertBg.backgroundColor = .clear
        viewAlertBg.addSubview(container)
        container.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        container.addSubview(bgView)
        viewAlertBg.addSubview(topIcon)
        container.addSubview(titleBg)
        container.addSubview(titleLabel)
        container.addSubview(mediumLine)
        container.addSubview(descLabel0)
        container.addSubview(descLabel1)
        container.addSubview(enterBtn)
        
        let bgSize = CGSize(width: 310, height: 344)
        var bgWidth: CGFloat = 0.0
        if UIScreen.main.bounds.width >= 375 {
            let standSW: CGFloat = 375.0
            bgWidth = bgSize.width  *  UIScreen.main.bounds.width / standSW
        } else {
            bgWidth = 290.0
        }
        bgView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(bgWidth)
            $0.height.equalTo(bgWidth * bgSize.height / bgSize.width)
            $0.edges.equalTo(container.snp.edges)
        }
        topIcon.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 102, height: 102))
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(bgView.snp.top).offset(-8)
        }
        titleBg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 175, height: 40))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topIcon.snp.bottom).offset(12)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(titleBg.snp.left).offset(2)
            $0.right.equalTo(titleBg.snp.right).offset(-2)
            $0.top.equalTo(titleBg.snp.top).offset(8)
            $0.bottom.equalTo(titleBg.snp.bottom).offset(-13)
        }
        mediumLine.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 114, height: 9))
            $0.top.equalTo(titleBg.snp.bottom).offset(13)
        }
        descLabel0.snp.makeConstraints {
            $0.top.equalTo(mediumLine.snp.bottom).offset(CGFloat(27))
            $0.height.equalTo(14)
            $0.centerX.equalToSuperview()
        }
        descLabel1.snp.makeConstraints {
            $0.top.equalTo(descLabel0.snp.bottom).offset(CGFloat(10))
            $0.height.equalTo(19)
            $0.centerX.equalToSuperview()
        }
        enterBtn.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 240, height: 50))
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-30)
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
