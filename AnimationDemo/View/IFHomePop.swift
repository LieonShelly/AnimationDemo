//
//  IFHomePop.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/30.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class IFHomePop: UIView {
    struct UISize {
        static let textH: CGFloat = 24
        static let textTop: CGFloat = 10
        static let textBottom: CGFloat = 20
        static let hInset: CGFloat = 22
    }
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.customFont(ofSize: 15, isBold: false)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.text = "点击这里开始修图～"
        return titleLabel
    }()
    
    fileprivate lazy var popShapeView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "pop")
        return view
    }()
       
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(popShapeView)
        addSubview(titleLabel)
        popShapeView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(47)
            $0.width.equalTo(172)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(9)
            $0.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
