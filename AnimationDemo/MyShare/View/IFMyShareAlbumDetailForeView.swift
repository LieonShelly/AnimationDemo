//
//  IFMyShareAlbumDetailForeView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/26.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class IFMyShareAlbumDetailForeView: UIView {
    struct UISize {
        static let preViewSize = CGSize(width: UIScreen.main.bounds.height <= 667 ? 230 * 0.6 : 230,
                                        height: UIScreen.main.bounds.height <= 667 ? 59 * 0.6 : 59)
    }
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 12)
        label.textColor = UIColor.white
        label.alpha = 0.2
        let attr0 = NSMutableAttributedString(string: "COUNT")
        attr0.addAttributes([.font: UIFont(name: "PingFangSC-Light", size: 12)!,
                             .foregroundColor: UIColor.white,
                             .kern: 1.5],
                            range: NSRange(location: 0, length: attr0.string.count))
        attr0.append(NSAttributedString(string: " "))
        
        let attr1 = NSMutableAttributedString(string: "DOWN")
        attr1.addAttributes([.font: UIFont(name: "PingFangSC-Light", size: 12)!,
                             .foregroundColor: UIColor.white,
                             .kern: 1.5],
                            range: NSRange(location: 0, length: attr1.string.count))
        attr0.append(attr1)
        label.attributedText = attr0
        return label
    }()
    fileprivate lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Light", size: 16)
        label.textColor = UIColor(hex: 0xeccbb5)
        label.text = "照片分享有效期".localized(nil)
        return label
    }()
    
    fileprivate lazy var foreView: UIImageView = {
        let foreView = UIImageView()
        let isCN = String.getLocLanguage() == "zh-Hans"
        if isCN {
            foreView.image = UIImage(named: "ic_my_share_fore_en")
            
//            foreView.image = UIImage(named: "ic_my_share_fore")
        } else {
            foreView.image = UIImage(named: "ic_my_share_fore_en")
        }
        return foreView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(foreView)
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
        foreView.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(7)
            $0.size.equalTo(UISize.preViewSize)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
