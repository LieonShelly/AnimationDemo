//
//  IFSettingFooterView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/1.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class IFSettingFooterView: UITableViewHeaderFooterView {
    fileprivate lazy var titleLabel: UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.font = UIFont.customFont(ofSize: 10)
        subTitleLabel.text = "Ver 1.0.1 inFace Studio"
        subTitleLabel.textColor = UIColor(hex: 0xe6e6e6)
        return subTitleLabel
    }()
    fileprivate lazy var subTitleLabel: UIButton = {
        let subTitleLabel = UIButton()
        subTitleLabel.titleLabel?.font = UIFont.customFont(ofSize: 10)
        subTitleLabel.setTitle("条款与申明", for: .normal)
        subTitleLabel.setTitleColor(UIColor(hex: 0xe6e6e6), for: .normal)
        return subTitleLabel
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(subTitleLabel.snp.top).offset(-6)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(14)
        }
        subTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(-(UIDevice.current.isiPhoneXSeries ? 69 : 69 - UIDevice.current.safeAreaInsets.bottom))
            $0.height.equalTo(14)
            $0.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
