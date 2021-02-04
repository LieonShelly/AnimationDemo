//
//  MenuCommonIconTitleCell.swift
//  AnimationDemo
//
//  Created by lieon on 2021/2/4.
//  Copyright © 2021 lieon. All rights reserved.
//

import UIKit

class MenuCommonIconTitleCell: UICollectionViewCell {
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = "梦境"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(icon)
        contentView.addSubview(titleLabel)
        icon.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-10)
        }
        titleLabel.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.height.equalTo(20)
            $0.bottom.equalTo(-5)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
