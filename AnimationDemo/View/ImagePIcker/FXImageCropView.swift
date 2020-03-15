//
//  FXImageCropView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/15.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class FXImageCropView: UIView {
    internal lazy var blurCover: VisualEffectView = {
        let maskView = VisualEffectView()
        maskView.isUserInteractionEnabled = false
        maskView.blurRadius = 20
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
        let offsetX = scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0
        let offsetY = scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0
        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
extension FXImageCropView {
    
    func configImage(_ image: UIImage, overLayerSize: CGSize) {
        imageView.image = image
        self.overLayerSize = overLayerSize
        imageView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.width * image.size.height / image.size.width)
        scrollViewDidZoom(scrollView)
        setNeedsLayout()
    }
}
