//
//  FX3DLightExchangeLightSourceBtn.swift
//  AnimationDemo
//
//  Created by lieon on 2020/8/29.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation
import UIKit

class FX3DLightExchangeLightSourceBtn: UIView {
    var tapAction: (() -> Void)?
    fileprivate lazy var tapBtn: UIButton = {
        let tapBtn = UIButton()
        return tapBtn
    }()
    fileprivate lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    fileprivate lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bottomView)
        addSubview(topView)
        addSubview(tapBtn)
        
        tapBtn.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        bottomView.snp.makeConstraints {
            $0.right.top.equalTo(0)
            $0.size.equalTo(CGSize(width: 20, height: 20))
        }
        topView.snp.makeConstraints {
            $0.left.bottom.equalTo(0)
            $0.size.equalTo(CGSize(width: 27, height: 27))
        }
        tapBtn.addTarget(self, action: #selector(tapBtnClick), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension FX3DLightExchangeLightSourceBtn {
    @objc
    fileprivate func tapBtnClick() {
        tapAction?()
    }
}
