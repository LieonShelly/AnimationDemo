//
//  FXLoginTitleCell.swift
//  PgImageProEditUISDK
//
//  Created by lieon on 2020/5/28.
//

import UIKit

class FXLoginTitleCell: UITableViewCell {
    fileprivate lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        return line
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "inFace欢迎您"
        label.font = UIFont.customFont(ofSize: 20, isBold: true)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.bottom.equalTo(0)
            $0.height.equalTo(0.5)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.centerY.equalTo(snp.centerY)
        }
      
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
