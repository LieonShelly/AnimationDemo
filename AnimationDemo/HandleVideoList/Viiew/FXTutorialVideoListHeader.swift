//
//  FXTutorialVideoListHeader.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/15.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class FXTutorialVideoListHeader: UITableViewHeaderFooterView {
    lazy var titlelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 22, isBold: true)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlelabel)
        titlelabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(18)
            $0.height.equalTo(22)
            $0.bottom.equalTo(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
