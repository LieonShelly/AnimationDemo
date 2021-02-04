//
//  MenuCommonToolbarView.swift
//  AnimationDemo
//
//  Created by lieon on 2021/2/3.
//  Copyright © 2021 lieon. All rights reserved.
//

import UIKit

class MenuCommonToolbarView: UIView {

    fileprivate lazy var cancleBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("重做", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    fileprivate lazy var enterBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("撤销", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    fileprivate lazy var restoreBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("还原", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    fileprivate lazy var contrastBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("对比", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    fileprivate lazy var slider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cancleBtn)
        addSubview(enterBtn)
        addSubview(restoreBtn)
        addSubview(contrastBtn)
        addSubview(slider)
        
        cancleBtn.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        enterBtn.snp.makeConstraints {
            $0.left.equalTo(cancleBtn.snp.right).offset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        slider.snp.makeConstraints {
            $0.left.equalTo(enterBtn.snp.right).offset(10)
            $0.right.equalTo(restoreBtn.snp.left).offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        restoreBtn.snp.makeConstraints {
            $0.right.equalTo(contrastBtn.snp.left).offset(-10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        contrastBtn.snp.makeConstraints {
            $0.right.equalTo(-10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
