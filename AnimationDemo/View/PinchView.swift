//
//  PinchView.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/11.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class PinchView: UIView {
    lazy var pointsA: [CGPoint] = []
    lazy var pointsB: [CGPoint] = []
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 10
        return scrollView
    }()
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "balloon")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        imageView.center = center
        imageView.sizeToFit()
    }
}

extension PinchView {
    fileprivate func configUI() {
        scrollView.delegate = self
        addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
}

extension PinchView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        guard let pinch = scrollView.pinchGestureRecognizer else {
            return
         }
        if pinch.numberOfTouches < 2 {
            return
        }
        let location0 = pinch.location(ofTouch: 0, in: scrollView)
        let location1 = pinch.location(ofTouch: 1, in: scrollView)
        pointsA.removeAll()
        pointsB.removeAll()
        pointsA.append(location0)
        pointsB.append(location1)
        debugPrint("location0:\(location0) - location1:\(location1)")
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        imageView.frame.origin.y = (scrollView.frame.size.height - imageView.frame.size.height) > 0 ?
//        (scrollView.frame.size.height - imageView.frame.size.height) * 0.5 : 0
//        imageView.frame.origin.x = (scrollView.frame.size.width - imageView.frame.size.width) > 0 ? (scrollView.frame.size.width - imageView.frame.size.width) * 0.5 : 0
        scrollView.contentSize = CGSize(width: imageView.frame.size.width + 30, height: imageView.frame.size.height + 30)
        guard let pinch = scrollView.pinchGestureRecognizer else {
            return
        }
        if pinch.numberOfTouches < 2 {
                 return
             }
        let location0 = pinch.location(ofTouch: 0, in: scrollView)
        let location1 = pinch.location(ofTouch: 1, in: scrollView)
        pointsA.append(location0)
        pointsB.append(location1)
        debugPrint("location0:\(location0) - location1:\(location1)")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
}
