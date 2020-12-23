//
//  IFMyShareAlbumDetailBgView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/22.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class IFMyShareAlbumDetailBgView: UIView {
    fileprivate lazy var topBgView: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "ic_my_share_detail_top_bg"))
        return icon
    }()
    fileprivate lazy var bottomView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_my_share_detail_bottombg")
        return imageView
    }()
    fileprivate lazy var bgView: FXGradientView = {
        let bgView = FXGradientView()
        let layer = bgView.layer as? CAGradientLayer
        layer?.colors = [UIColor(hex: 0x2b2b2b)!.cgColor, UIColor(hex: 0x171717)!.cgColor]
        layer?.startPoint = .zero
        layer?.endPoint = CGPoint(x: 1.0, y: 1.0)
        return bgView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(topBgView)
        addSubview(bottomView)
        bgView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        topBgView.snp.makeConstraints {
            $0.left.top.right.equalTo(0)
            $0.height.equalTo(169)
        }
        bottomView.snp.makeConstraints {
            $0.left.bottom.equalTo(0)
            $0.size.equalTo(CGSize(width: 291, height: 178))
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

