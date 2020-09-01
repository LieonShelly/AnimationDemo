//
//  IFFuncChooseSectionHeader.swift
//  InFace
//
//  Created by lieon on 2020/7/9.
//  Copyright © 2020 Pinguo. All rights reserved.
//

import UIKit

class IFFuncChooseSectionHeader: UIView {
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0x333333)
        label.text = "选择编辑方式"//.localized(nil)
        label.font = UIFont.customFont(ofSize: 14, isBold: true)
        return label
    }()
    
    fileprivate lazy var line: IFGradientView = {
        let view = IFGradientView()
        view.layer.cornerRadius = 1.5
        view.layer.masksToBounds = true
        view.alpha = 0.8
        (view.layer as? CAGradientLayer)?.startPoint = CGPoint(x: 0.5, y: 0)
        (view.layer as? CAGradientLayer)?.endPoint = CGPoint(x: 0.5, y: 1)
        (view.layer as? CAGradientLayer)?.colors = [UIColor(hex: 0xffaae3)!.cgColor, UIColor(hex: 0xcf96ff)!.cgColor]
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.width.equalTo(3)
            $0.height.equalTo(14)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(line.snp.right).offset(6)
            $0.height.equalTo(14)
            $0.centerY.equalTo(line.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
