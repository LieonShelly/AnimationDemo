//
//  IFSettingHeaderView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/1.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class IFSettingHeaderView: UIView {
    fileprivate lazy var logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "ic_sidebar_logo")
        return logoView
    }()
    fileprivate lazy var nameView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "ic_setting_logo_dec_cn")
        return logoView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logoView)
        addSubview(nameView)
        logoView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 101, height: 101))
            $0.top.equalTo(0)
            $0.centerX.equalToSuperview()
        }
        nameView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 95, height: 41))
            $0.top.equalTo(logoView.snp.bottom).offset(21)
        }

    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
