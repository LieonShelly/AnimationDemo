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
    static var browsers: [String: Any?] = [:]
    var originFrame: CGRect = .zero
    var imageSize: CGSize = .zero
    fileprivate lazy var imageView: UIImageView = UIImageView()
    fileprivate lazy var blurView = FXTutorialBlurView(withRadius: 10)
    fileprivate lazy var contentView: UIView = UIView()
    
    convenience init(_ originFrame: CGRect,
                     image: UIImage,
                     frame: CGRect) {
        self.init(frame: frame)
        self.imageSize = image.size
        self.originFrame = originFrame
        configUI(frame)
        config(image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI(keyWindow.bounds)
    }
    
    func config(_ image: UIImage) {
        imageView.image = image
    }
    
    func dismiss() {
        showAnimation(false, imageSize: originFrame.size)
    }
    
    func showAnimation(_ presenting: Bool, imageSize: CGSize) {
        var initialFrame: CGRect = .zero
        var finalFrame: CGRect = .zero
        var xScaleFactor: CGFloat = 0
        var yScaleFactor: CGFloat = 0
        let inset: CGFloat = 15
        let width: CGFloat = UIScreen.main.bounds.width - inset * 2
        let height = imageSize.height * width / imageSize.width
        if presenting {
            initialFrame = originFrame
            finalFrame = CGRect(x: inset,
                                y: frame.origin.x + frame.size.height * 0.5 - height * 0.5,
                                width: width,
                                height: height)
            xScaleFactor = initialFrame.width / finalFrame.width
            yScaleFactor = initialFrame.height / finalFrame.height
        } else {
            initialFrame = CGRect(x: inset,
                                  y: frame.origin.x + frame.size.height * 0.5 - height * 0.5,
                                width: width,
                                height: height)
            finalFrame = originFrame
            xScaleFactor = finalFrame.width / initialFrame.width
            yScaleFactor = finalFrame.height / initialFrame.height
        }

        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        if presenting {
            contentView.frame = finalFrame
            self.contentView.transform = scaleTransform
            self.contentView.center = CGPoint(
               x: initialFrame.midX,
               y: initialFrame.midY)
           }
        UIView.animate(withDuration: 0.25, 
                          animations: {
                            self.contentView.transform = presenting ? CGAffineTransform.identity : scaleTransform
                            self.contentView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
           }, completion: { _ in
             if !presenting {
                self.removeFromSuperview()
             }
        })
    }

    static func show(_ image: UIImage, selectedFrame: CGRect) -> String {
        let view = PopImageBrowser(selectedFrame, image: image, frame: keyWindow.bounds)
        view.frame = keyWindow.bounds
        keyWindow.addSubview(view)
        let key = view.description
        PopImageBrowser.browsers[key] = view
        view.showAnimation(true, imageSize: image.size)
        return key
    }
    
    static func dismiss(_ key: String) {
        guard let view = browsers[key] as? PopImageBrowser else {
            return
        }
        view.dismiss()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    deinit {
        debugPrint("deinit-PopImage")
    }
}

extension PopImageBrowser {

    fileprivate func configUI(_ frame: CGRect) {
        addSubview(blurView)
        addSubview(contentView)
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        contentView.clipsToBounds = true
        contentView.frame = .zero
        contentView.addSubview(imageView)
        blurView.snp.makeConstraints {
              $0.edges.equalTo(0)
          }
        imageView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
}
