//
//  IFShareExceptionView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/24.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class IFExceptionView: UIView {
    struct UIEntity {
        var icon: UIImage
        var titleTop: CGFloat = 10
        var title: String
    }
    enum ExceptionType {
        case empty(UIEntity)
        case reload(UIEntity)
    }
    fileprivate lazy var icon: UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 14)
        titleLabel.textColor = UIColor(hex: 0x999999)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    fileprivate lazy var btn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        return btn
    }()
    fileprivate lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(titleLabel)
        addSubview(stack)
        addSubview(btn)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(_ type: ExceptionType) {
        switch type {
        case .empty(let uiEnty):
            icon.image = uiEnty.icon
            titleLabel.text = uiEnty.title
            stack.spacing = uiEnty.titleTop
            stack.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalTo(snp.centerY).offset(-30) //.offset(UIDevice.current.isiPhoneXSeries ? -60 : -30)
            }
            btn.isHidden = true
        case .reload(let uiEnty):
            icon.image = uiEnty.icon
            titleLabel.text = uiEnty.title
            stack.spacing = uiEnty.titleTop
            stack.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().offset(-30) //.offset(UIDevice.current.isiPhoneXSeries ? -60 : -30)
            }
            btn.isHidden = false
            btn.snp.remakeConstraints {
                $0.centerX.equalTo(stack.snp.centerX)
                $0.size.equalTo(CGSize(width: 190, height: 52))
                $0.top.equalTo(stack.snp.bottom).offset(161)
            }
        }
    }
}
