//
//  FX3DLightTypeChooseView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/9/16.
//  Copyright © 2020 lieon. All rights reserved.
//  光线类型选择器

import UIKit

class FX3DLightTypeChooseView: UIView {
    var btnDidTap: ((Int) -> Void)?
    fileprivate lazy var btn0: UIButton = {
        let btn0 = UIButton()
        btn0.titleLabel?.font = UIFont.customFont(ofSize: 13)
        btn0.setTitle("柔光".localized_FX(), for: .normal)
        btn0.setTitleColor(.white, for: .selected)
        btn0.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        btn0.tag = 0
        return btn0
    }()
    fileprivate lazy var btn1: UIButton = {
        let btn0 = UIButton()
        btn0.setTitle("聚光".localized_FX(), for: .normal)
        btn0.titleLabel?.font = UIFont.customFont(ofSize: 13)
        btn0.setTitleColor(.white, for: .selected)
        btn0.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        btn0.tag = 1
        return btn0
    }()
    fileprivate lazy var underLine0: UIView = {
        let line = UIView()
        line.backgroundColor = .white
        line.layer.cornerRadius = 0.5
        line.layer.masksToBounds = true
        return line
    }()
    fileprivate lazy var underLine1: UIView = {
        let line = UIView()
        line.backgroundColor = .white
        line.layer.cornerRadius = 0.5
        line.layer.masksToBounds = true
        return line
    }()
    fileprivate var selectedBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(btn0)
        addSubview(btn1)
        addSubview(underLine0)
         addSubview(underLine1)
        btn0.snp.makeConstraints {
            $0.left.equalTo(0)
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(18)
        }
        btn1.snp.makeConstraints {
            $0.right.equalTo(0)
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(18)
        }
        underLine0.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(14)
            $0.centerX.equalTo(btn0)
            $0.top.equalTo(btn0.snp.bottom).offset(5)
        }
        underLine1.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(14)
            $0.centerX.equalTo(btn1)
            $0.top.equalTo(btn1.snp.bottom).offset(5)
        }
        btn0.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        btn1.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        btnAction(btn0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension FX3DLightTypeChooseView {
    
    @objc
    fileprivate func btnAction(_ btn: UIButton) {
        selectedBtn?.isUserInteractionEnabled = true
        selectedBtn?.isSelected = false
        btn.isSelected = true
        selectedBtn = btn
        selectedBtn?.isUserInteractionEnabled = false
        switch btn.tag {
        case 0:
            underLine0.isHidden = false
            underLine1.isHidden = true
        case 1:
            underLine0.isHidden = true
            underLine1.isHidden = false
        default:
            break
        }
        btnDidTap?(btn.tag)
    }
}

