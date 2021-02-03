//
//  MenuCommonBottomView.swift
//  AnimationDemo
//
//  Created by lieon on 2021/2/3.
//  Copyright © 2021 lieon. All rights reserved.
//

import UIKit

class MenuCommonBottomView: UIView {
    fileprivate lazy var cancleBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    fileprivate lazy var enterBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cancleBtn)
        addSubview(enterBtn)
        addSubview(titleLabel)
        cancleBtn.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.centerY.equalToSuperview()
        }
        enterBtn.snp.makeConstraints {
            $0.right.equalTo(-10)
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func config(_ title: String) {
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
