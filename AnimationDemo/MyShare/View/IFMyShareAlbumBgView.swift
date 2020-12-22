//
//  IFMyShareAlbumBgView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/22.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class IFMyShareAlbumBgView: UIView {
    fileprivate lazy var rightView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_myshare_bg_ic")
        return imageView
    }()
    fileprivate lazy var bgView: FXGradientView = {
        let bgView = FXGradientView()
        let layer = bgView.layer as? CAGradientLayer
        layer?.colors = [UIColor(hex: 0x171717)!.cgColor, UIColor(hex: 0x2b2b2b)!.cgColor]
        layer?.startPoint = CGPoint(x: 0.5, y: 0)
        layer?.endPoint = CGPoint(x: 0.5, y: 1)
        return bgView
    }()
    fileprivate lazy var leftView: FXGradientView = {
        let bgView = FXGradientView()
        let layer = bgView.layer as? CAGradientLayer
        layer?.colors = [UIColor(hex: 0x2b2b2b)!.cgColor, UIColor(hex: 0x171717)!.cgColor]
        layer?.startPoint = CGPoint(x: 0.5, y: 0)
        layer?.endPoint = CGPoint(x: 0.5, y: 1)
        return bgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(leftView)
        addSubview(rightView)
        bgView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        rightView.snp.makeConstraints {
            $0.right.top.equalTo(0)
            $0.height.equalTo(169)
            $0.width.equalTo(220)
        }
        leftView.snp.makeConstraints {
            $0.left.top.equalTo(0)
            $0.height.equalTo(350)
            $0.right.equalTo(rightView.snp.left)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

