//
//  IFMyShareAlbumTimeLineView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/22.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class IFMyShareAlbumTimeLineView: UIView {
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 12)
        label.textColor = UIColor.white
        label.text = "COUNT DOWN"
        label.alpha = 0.2
        return label
    }()
    fileprivate lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 16)
        label.textColor = UIColor(hex: 0xeccbb5)
        label.text = "距离分享结束还有"
        return label
    }()
    fileprivate lazy var hourView: IFMyShareAlbumTimeView = {
        let view = IFMyShareAlbumTimeView()
        return view
    }()
    fileprivate lazy var minuteView: IFMyShareAlbumTimeView = {
        let view = IFMyShareAlbumTimeView()
        return view
    }()
    fileprivate lazy var secondView: IFMyShareAlbumTimeView = {
        let view = IFMyShareAlbumTimeView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(hourView)
        addSubview(minuteView)
        addSubview(secondView)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.top.equalTo(0)
            $0.height.equalTo(17)
        }
        subtitleLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.top.equalTo(titleLabel.snp.bottom).offset(1)
            $0.height.equalTo(22)
        }
        let stack = UIStackView(arrangedSubviews: [hourView, minuteView, secondView])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        hourView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 53 + 5 + 12, height: 52))
        }
        minuteView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 53 + 5 + 12, height: 52))
        }
        secondView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 53 + 5 + 12, height: 52))
        }
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

