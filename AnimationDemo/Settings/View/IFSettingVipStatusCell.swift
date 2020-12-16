//
//  IFSettingVipStatusCell.swift
//  InFace
//
//  Created by lieon on 2020/11/30.
//  Copyright © 2020 Pinguo. All rights reserved.
//

import UIKit

class IFSettingVipStatusCell: UITableViewCell {
    fileprivate lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(named: "ic_setting_vip")
        return iconView
    }()
    fileprivate lazy var arrowView: UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(named: "ic_setting_vip_arrow")
        return iconView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.customFont(ofSize: 16, isBold: true)
        titleLabel.textColor = UIColor(hex: 0x935f38)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    fileprivate lazy var freeTitlabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.customFont(ofSize: 14, isBold: false)
        titleLabel.textColor = UIColor(hex: 0xe5c9b6)
        return titleLabel
    }()
    
    fileprivate lazy var vipSubTitlebal: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.customFont(ofSize: 12, isBold: false)
        titleLabel.textColor = UIColor(hex: 0xc1c1c1)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    fileprivate lazy var backView: UIImageView = {
        let line = UIImageView()
        line.image = UIImage(named: "ic_setting_notvip_bg")
        line.contentMode = .scaleAspectFill
        line.layer.cornerRadius = 2
        line.layer.masksToBounds = true
        return line
    }()
    fileprivate lazy var shadowView: FXShadowView = {
        let shadowView = FXShadowView()
        shadowView.shadowRadius = 15
        shadowView.shadowOffset = CGSize(width: 0, height: 8)
        shadowView.cornerRadius = 2
        shadowView.shadowOpacity = 1
        shadowView.isHidden = false
        return shadowView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(shadowView)
        contentView.addSubview(backView)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(vipSubTitlebal)
        contentView.addSubview(freeTitlabel)
        contentView.addSubview(arrowView)
        backView.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.top.equalTo(0)
            $0.height.equalTo(64)
        }
        shadowView.snp.makeConstraints {
            $0.edges.equalTo(backView.snp.edges)
        }
        iconView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.centerY.equalTo(backView.snp.centerY)
            $0.left.equalTo(backView.snp.left).offset(18)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(iconView.snp.centerY)
            $0.left.equalTo(iconView.snp.right).offset(12)
            $0.right.equalTo(-50)
        }
        arrowView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 12, height: 12))
            $0.centerY.equalTo(iconView.snp.centerY)
            $0.right.equalTo(backView.snp.right).offset(-20)
        }
        vipSubTitlebal.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backView.snp.bottom).offset(14)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
        }
        freeTitlabel.snp.makeConstraints {
            $0.centerY.equalTo(iconView.snp.centerY)
            $0.right.equalTo(arrowView.snp.left).offset(-4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(_ isVip: IFSettingVipStatus) {
        switch isVip {
        case .notVip:
            titleLabel.text = isVip.data.title
            freeTitlabel.text = isVip.data.subTitle
            vipSubTitlebal.isHidden = true
            freeTitlabel.isHidden = false
            backView.image = UIImage(named: "ic_setting_notvip_bg")
            shadowView.shadowColor = UIColor(hex: 0x070707)!.withAlphaComponent(0.15).cgColor
            arrowView.image = UIImage(named: "ic_setting_notvip_arrow")
            titleLabel.textColor = UIColor(hex: 0xe5c9b6)
            
        case .vip:
            titleLabel.textColor = UIColor(hex: 0x935f38)
            titleLabel.text = isVip.data.title
            vipSubTitlebal.text = isVip.data.subTitle
            vipSubTitlebal.isHidden = false
            freeTitlabel.isHidden = true
            backView.image = UIImage(named: "ic_setting_vip_bg")
            shadowView.shadowColor = UIColor(hex: 0xEBCEBB)!.withAlphaComponent(0.4).cgColor
            arrowView.image = UIImage(named: "ic_setting_vip_arrow")
        }
    }
}
