//
//  FXBannerCollectionViewCell.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/12.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class FXBannerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowRadius = 20
        shadowView.layer.shadowOpacity = 0.4
    }

}
