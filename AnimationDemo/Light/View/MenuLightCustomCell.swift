//
//  MenuLightCustomCell.swift
//  AnimationDemo
//
//  Created by lieon on 2021/2/3.
//  Copyright © 2021 lieon. All rights reserved.
//

import UIKit

class MenuLightCustomCell: MenuCommonPicTitleCell {
    lazy var editIcon: UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    fileprivate lazy var blurBg: UIVisualEffectView = {
        let effect = UIBlurEffect()
        let bgView = UIVisualEffectView(effect: effect)
        return bgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
