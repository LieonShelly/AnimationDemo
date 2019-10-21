//
//  PadTypeCollectionViewCell.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/21.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class PadTypeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cornorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cornorView.layer.cornerRadius = 10
        cornorView.layer.masksToBounds = true
        cornorView.layer.borderColor = UIColor.yellow.cgColor
        cornorView.layer.borderWidth = 1
    }
    
    func config(_ data: TextInputModel) {
        cornorView.layer.borderColor = data.isSelect ? UIColor.red.cgColor : UIColor.yellow.cgColor
        cornorView.layer.borderWidth = 1
        label.text = data.keyboardDesc
    }

}
