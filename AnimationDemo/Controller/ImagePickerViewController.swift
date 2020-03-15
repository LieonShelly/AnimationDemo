//
//  ImagePickerViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/15.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIViewController {
    fileprivate lazy var imagePicker: FXImageCropView = {
        let imagePicker = FXImageCropView()
        return imagePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        imagePicker.frame = view.bounds
        view.addSubview(imagePicker)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imagePicker.configImage(UIImage(named: "meinv")!, overLayerSize: CGSize(width: view.bounds.width - 15 * 2, height: 400))
    }
}
