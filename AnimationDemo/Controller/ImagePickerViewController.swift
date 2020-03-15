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
        let image = UIImage(named: "meinv")!
        let imageSize = image.size
        var overLayerSize = CGSize(width: view.bounds.width - 15 * 2, height: 400)
        overLayerSize.height = overLayerSize.width * imageSize.width / imageSize.height
        var finalScaleFactor: CGFloat = 0
        let inset: CGFloat = 15
        let width: CGFloat = UIScreen.main.bounds.width - inset * 2
        let height: CGFloat = 400
        if imageSize.width / width > imageSize.height / height {
            finalScaleFactor = imageSize.width / width
        }else{
            finalScaleFactor = imageSize.height / height
        }
        let finalHeight = imageSize.height / finalScaleFactor
        overLayerSize.height = finalHeight
        imagePicker.configImage(image, overLayerSize: overLayerSize)
    }
}
