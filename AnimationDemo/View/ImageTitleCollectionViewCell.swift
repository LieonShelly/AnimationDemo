//
//  ImageTitleCollectionViewCell.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/29.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class ImageTitleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.backgroundColor = UIColor.lightGray
    }
}
