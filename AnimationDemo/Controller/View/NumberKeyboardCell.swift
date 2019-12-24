//
//  NumberKeyboardCell.swift
//  AnimationDemo
//
//  Created by lieon on 2019/12/24.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class NumberKeyboardCell: UICollectionViewCell {
    @IBOutlet weak var label: UIButton!
    var btnDidTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.them
    }

    @IBAction func btnTapAction(_ sender: Any) {
        btnDidTap?()
    }
}
