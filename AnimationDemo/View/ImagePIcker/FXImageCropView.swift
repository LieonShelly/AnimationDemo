//
//  FXImageCropView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/15.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class FXImageCropView: UIView {
    internal lazy var blurCover: UIView = { // VisualEffectView
        let maskView = UIView()
        maskView.isUserInteractionEnabled = false
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return maskView
    }()
    fileprivate lazy var overLayer: CropOverlay = {
        let overLayer = CropOverlay()
        overLayer.isMovable = false
        overLayer.isUserInteractionEnabled = false
        return overLayer
    }()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.maximumZoomScale = 5
        scrollView.minimumZoomScale = 1
        return scrollView
    }()
    
    fileprivate lazy var overLayerSize: CGSize = .zero
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "meinv"))
        return imageView
    }()
    fileprivate lazy var blurCoverMaskShape: CAShapeLayer = {
        let blurCoverMaskShape = CAShapeLayer()
        return blurCoverMaskShape
    }()
    fileprivate var horisonInset: CGFloat = 0
    fileprivate var verticalInset: CGFloat = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        addSubview(overLayer)
        addSubview(blurCover)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        overLayer.frame = CGRect(x: (bounds.width - overLayerSize.width) * 0.5,
                                 y: (bounds.height - overLayerSize.height) * 0.5,
                                 width: overLayerSize.width, height: overLayerSize.height)
        blurCover.frame = bounds
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let maskPath = UIBezierPath(rect: bounds)
        let clearPath = UIBezierPath()
        clearPath.move(to: CGPoint(x: (bounds.width - overLayerSize.width) * 0.5, y: (bounds.height - overLayerSize.height) * 0.5))
        clearPath.addLine(to: CGPoint(x: (bounds.width - overLayerSize.width) * 0.5, y: (bounds.height - overLayerSize.height) * 0.5 + overLayerSize.height))
        clearPath.addLine(to: CGPoint(x: (bounds.width - overLayerSize.width) * 0.5 + overLayerSize.width, y: (bounds.height - overLayerSize.height) * 0.5 + overLayerSize.height))
        clearPath.addLine(to: CGPoint(x: (bounds.width - overLayerSize.width) * 0.5 + overLayerSize.width, y: (bounds.height - overLayerSize.height) * 0.5))
        clearPath.addLine(to: CGPoint(x: (bounds.width - overLayerSize.width) * 0.5, y: (bounds.height - overLayerSize.height) * 0.5))
        clearPath.close()
        maskPath.append(clearPath)
        blurCoverMaskShape.path = maskPath.cgPath
        blurCover.layer.mask = blurCoverMaskShape
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension FXImageCropView: UIScrollViewDelegate {
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        scrollView.contentSize = CGSize(width: (scrollView.contentSize.width + horisonInset), height: scrollView.contentSize.height + verticalInset)
        let offsetX = scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0
        let offsetY = scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0
        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
        debugPrint("contentSize: \(scrollView.contentSize)")
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
extension FXImageCropView {
    
    func configImage(_ image: UIImage, overLayerSize: CGSize) {
        imageView.image = image
        self.overLayerSize = overLayerSize
        imageView.frame.size = CGSize(width: scrollView.bounds.width, height: scrollView.bounds.width * image.size.height / image.size.width)
//        scrollView.contentSize = scrollView.bounds.size
//        horisonInset = bounds.width - overLayerSize.width
//        verticalInset = (bounds.height - overLayerSize.height) / 2
        scrollViewDidZoom(scrollView)
        setNeedsLayout()
    }
}
