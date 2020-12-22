//
//  IFMyShareAlbumDetailTimeView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/22.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class IFMyShareAlbumDetailTimeView: UIView {
    struct UISize {
        static let numSize = CGSize(width: 53, height: 52)
        static let spacing: CGFloat = 3
        static let textSize = CGSize(width: 12, height: 17)
    }
    fileprivate lazy var gradientView: FXGradientView = {
        let view = FXGradientView()
        let layer = view.layer as? CAGradientLayer
        layer?.colors = [UIColor(hex: 0xcead97)!.cgColor, UIColor(hex: 0xf0d2bf)!.cgColor]
        return view
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        // FIXME: FONT
        label.font = UIFont.customFont(ofSize: 40, isBold: true)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.text = "27"
        return label
    }()
    fileprivate lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 12)
        label.textColor = UIColor(hex: 0xdabaa5)
        label.text = "时"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(gradientView)
        addSubview(subtitleLabel)
        gradientView.snp.makeConstraints {
            $0.left.equalTo(0)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(UISize.numSize)
        }
        subtitleLabel.snp.makeConstraints {
            $0.left.equalTo(gradientView.snp.right).offset(UISize.spacing)
            $0.bottom.equalTo(gradientView.snp.bottom).offset(-7)
            $0.size.equalTo(UISize.textSize)
        }
        gradientView.layer.mask = titleLabel.layer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 0, y: 0, width: UISize.numSize.width, height: UISize.numSize.height)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func config(_ title: String, subTitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subTitle
        setNeedsLayout()
    }
}
