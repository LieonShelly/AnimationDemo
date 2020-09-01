//
//  IFHomeTutorialListBgView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/7/9.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation

class IFHomeTutorialListBgView: UIView {
    fileprivate lazy var bgView: IFGradientView = {
        let bgView = IFGradientView()
        let gradientLayer = bgView.layer as? CAGradientLayer
        gradientLayer?.locations = [0, 0.236, 0.482, 0.654, 0.941, 1.0]
        gradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer?.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer?.colors = [0xf5a5d7,
                                 0xffd0e0,
                                 0xffe2df,
                                 0xfff6ec,
                                 0xffffff].map { UIColor(hex: $0)!.cgColor}
        return bgView
    }()
    
    fileprivate lazy var whiteCover: IFGradientView = {
        let view = IFGradientView()
        (view.layer as? CAGradientLayer)?.locations = [0, 1]
        view.isHidden = true
        view.isUserInteractionEnabled = false
        view.alpha = 0
        let gradientLayer = view.layer as? CAGradientLayer
        gradientLayer?.colors = [
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.withAlphaComponent(0.5).cgColor,
            UIColor.white.withAlphaComponent(0.8).cgColor,
            UIColor.white.withAlphaComponent(1).cgColor,
            UIColor.white.withAlphaComponent(1).cgColor,
            UIColor.white.cgColor]
        gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer?.endPoint = CGPoint(x: 0.5, y: 0.95)
        gradientLayer?.locations = [0, 0.15, 0.45, 0.76, 0.87, 1]
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(whiteCover)
        bgView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        whiteCover.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
