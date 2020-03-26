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
        addSubview(imageView)
        addSubview(blurCover)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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

extension FXImageCropView {
    
    func configImage(_ image: UIImage, overLayerSize: CGSize) {
        imageView.image = image
        self.overLayerSize = overLayerSize
        let scale = min(overLayerSize.width / image.size.width, overLayerSize.height / image.size.height)
        let scaleSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        imageView.frame.size = scaleSize
        imageView.frame.origin.x = (bounds.width - scaleSize.width) * 0.5
        imageView.frame.origin.y = (bounds.height - scaleSize.height) * 0.5
        setNeedsLayout()
        
        /**
         CGFloat scale = 0.0f;
           
           // Work out the size of the image to fit into the content bounds
           scale = MIN(CGRectGetWidth(bounds)/imageSize.width, CGRectGetHeight(bounds)/imageSize.height);
           CGSize scaledImageSize = (CGSize){floorf(imageSize.width * scale), floorf(imageSize.height * scale)};
           
           // If an aspect ratio was pre-applied to the crop view, use that to work out the minimum scale the image needs to be to fit
           CGSize cropBoxSize = CGSizeZero;
           if (self.hasAspectRatio) {
               CGFloat ratioScale = (self.aspectRatio.width / self.aspectRatio.height); //Work out the size of the width in relation to height
               CGSize fullSizeRatio = (CGSize){boundsSize.height * ratioScale, boundsSize.height};
               CGFloat fitScale = MIN(boundsSize.width/fullSizeRatio.width, boundsSize.height/fullSizeRatio.height);
               cropBoxSize = (CGSize){fullSizeRatio.width * fitScale, fullSizeRatio.height * fitScale};
               
               scale = MAX(cropBoxSize.width/imageSize.width, cropBoxSize.height/imageSize.height);
           }

           //Whether aspect ratio, or original, the final image size we'll base the rest of the calculations off
           CGSize scaledSize = (CGSize){floorf(imageSize.width * scale), floorf(imageSize.height * scale)};
         
         */
       
    }
}
