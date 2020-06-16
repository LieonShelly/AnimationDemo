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
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
