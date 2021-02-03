//
//  MennuCommonIconTitleCell.swift
//  AnimationDemo
//
//  Created by lieon on 2021/2/3.
//  Copyright © 2021 lieon. All rights reserved.
//

import UIKit

class MennuCommonIconTitleCell: UICollectionViewCell {
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        label.text = "梦境"
        label.textAlignment = .center
        label.backgroundColor = UIColor.blue.withAlphaComponent(0.7)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(icon)
        contentView.addSubview(titleLabel)
        icon.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        titleLabel.snp.makeConstraints {
            $0.left.right.bottom.equalTo(0)
            $0.height.equalTo(10)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
