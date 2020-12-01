//
//  IFSettingCommonCell.swift
//  InFace
//
//  Created by lieon on 2020/11/30.
//  Copyright © 2020 Pinguo. All rights reserved.
//

import Foundation
import UIKit

class IFSettingCommonCell: UITableViewCell {
    fileprivate lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        return iconView
    }()
    fileprivate lazy var arrowView: UIImageView = {
        let iconView = UIImageView()
        return iconView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.customFont(ofSize: 14)
        titleLabel.textColor = UIColor(hex: 0x333333)
        return titleLabel
    }()
    fileprivate lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hex: 0xe7e7e7)
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowView)
        contentView.addSubview(line)
        iconView.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.size.equalTo(CGSize(width: 20, height: 20))
            $0.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(16)
            $0.centerY.equalToSuperview()
        }
        arrowView.snp.makeConstraints {
            $0.right.equalTo(-20)
            $0.centerY.equalToSuperview()
        }
        line.snp.makeConstraints {
            $0.bottom.equalTo(0)
            $0.height.equalTo(0.5)
            $0.left.equalTo(20)
            $0.right.equalTo(0)
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func config(_ icon: UIImage, title: String, arrow: UIImage, isHiddenLine: Bool) {
        iconView.image = icon
        titleLabel.text = title
        arrowView.image = arrow
        line.isHidden = isHiddenLine
    }
}

