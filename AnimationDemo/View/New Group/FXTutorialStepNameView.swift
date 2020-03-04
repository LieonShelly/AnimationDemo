//
//  FXTutorialStepNameView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/4.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class FXTutorialStepNameView: UIView {
    fileprivate lazy var arrowBtn: UIButton = {
        let arrowBtn = UIButton(type: UIButton.ButtonType.system)
        arrowBtn.setTitle("点击", for: .normal)
        arrowBtn.titleLabel?.font = UIFont.customFont(ofSize: 12)
        return arrowBtn
    }()

}
