//
//  PopImageBrowser.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/29.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

let keyWindow = UIApplication.shared.keyWindow!

class PopImageBrowser: UIView {
    var originFrame: CGRect = .zero
    fileprivate lazy var imageView: UIImageView = UIImageView()
    
    convenience init(_ originFrame: CGRect,
                     image: UIImage,
                     frame: CGRect) {
        self.init(frame: frame)
        self.originFrame = originFrame
        configUI()
        config(image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
         configUI()
    }
    
    func config(_ image: UIImage) {
        imageView.image = image
    }
    
    func dismiss() {
        showAnimation(false)
    }
    
    func showAnimation(_ presenting: Bool) {
        let initialFrame = presenting ? originFrame : frame
        let finalFrame = presenting ? frame : originFrame
        let xScaleFactor = presenting ?
                            initialFrame.width / finalFrame.width :
                            finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ?
                            initialFrame.height / finalFrame.height :
                            finalFrame.height / initialFrame.height

        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        if presenting {
             self.transform = scaleTransform
             self.center = CGPoint(
               x: initialFrame.midX,
               y: initialFrame.midY)
           }
        UIView.animate(withDuration: 0.25, delay:0.0, usingSpringWithDamping: 0.4,
                          initialSpringVelocity: 0.0,
                          animations: {
                           self.transform = presenting ? CGAffineTransform.identity : scaleTransform
                           self.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
           }, completion: { _ in
             if !presenting {
                self.removeFromSuperview()
             }
        })
    }

    static func show(_ image: UIImage, selectedFrame: CGRect) {
        let view = PopImageBrowser(selectedFrame, image: image, frame: keyWindow.bounds)
        keyWindow.addSubview(view)
        view.showAnimation(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    deinit {
        debugPrint("deinit-PopImage")
    }
}

extension PopImageBrowser {

    fileprivate func configUI() {
        backgroundColor = UIColor.white.withAlphaComponent(0.3)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let centerX = imageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        let centerY = imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        let leading = imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10)
        let trailing = imageView.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: 10)
        let top = imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10)
        let bottom = imageView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: 10)
        NSLayoutConstraint.activate([centerX, centerY, leading, trailing, top, bottom])
    }
    
}
