//
//  FXTutorialManulVideoHandleCell.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/15.
//  Copyright © 2020 lieon. All rights reserved.
//  教程技巧Cell

import UIKit
import AVKit

class FXTutorialManulVideoHandleCell: FXTutorialManulVideoBaseCell {
    
    struct OtherUISize {
        static let titleTop: CGFloat = 8
        static let playerTop: CGFloat = 20
        static let playerBottom: CGFloat = 35 * 0.5
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(titlelabel)
        contentView.addSubview(shadowView)
        contentView.addSubview(playerView)
        contentView.addSubview(playerCoverView)
        
        titlelabel.snp.makeConstraints {
            $0.top.equalTo(OtherUISize.titleTop)
            $0.left.equalTo(10)
            $0.right.equalTo(-10)
        }
        playerView.snp.makeConstraints {
            $0.top.equalTo(titlelabel.snp.bottom).offset(OtherUISize.playerTop)
            $0.left.equalTo(UISize.playerHorizonInset)
            $0.right.equalTo(-UISize.playerHorizonInset)
            $0.bottom.equalTo(-OtherUISize.playerBottom)
        }
        shadowView.snp.makeConstraints {
            $0.edges.equalTo(playerView.snp.edges).inset(-0)
        }
        playerCoverView.snp.makeConstraints {
            $0.edges.equalTo(playerView.snp.edges)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class FXShadowView: UIView {
     var shadowColor: CGColor = UIColor(hex: 0x020207)!.cgColor
      var cornerRadius: CGFloat = 22
      var shadowOpacity: Float = 0.3
      var shadowOffset: CGSize = CGSize(width: 0, height: 7)
      var shadowRadius: CGFloat = 15
      
      override func layoutSublayers(of layer: CALayer) {
          super.layoutSublayers(of: layer)
          let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
          layer.shadowPath = path
          layer.shadowColor = shadowColor
          layer.shadowOpacity = shadowOpacity
          layer.shadowOffset = shadowOffset
          layer.shadowRadius = shadowRadius
      }
}

class FXInnerShadowView: UIView {
    fileprivate lazy var innerShadow: CALayer = {
        let innerShadowLayer = CALayer()
        return innerShadowLayer
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(innerShadow)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addInnerShadow()
    }
    
    private func addInnerShadow() {
        innerShadow.frame = bounds
        let path = UIBezierPath(rect: innerShadow.bounds.insetBy(dx: -1, dy: -1))
        let cutout = UIBezierPath(rect: innerShadow.bounds).reversing()
        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true
        innerShadow.shadowColor = UIColor(hex: 0x161616)!.cgColor
        innerShadow.shadowOffset = CGSize.zero
        innerShadow.shadowOpacity = 1
        innerShadow.shadowRadius = 10
        innerShadow.cornerRadius = 5
    }
}


class InnerShadowLayer: CAShapeLayer {
    var innerShadowColor: CGColor = UIColor.black.cgColor {
        didSet { setNeedsDisplay() }
    }
    
    var innerShadowOffset: CGSize = .zero {
        didSet { setNeedsDisplay() }
    }
    
    var innerShadowRadius: CGFloat = 8 {
        didSet { setNeedsDisplay() }
    }
    
    var innerShadowOpacity: Float = 1 {
        didSet { setNeedsDisplay() }
    }
    
    override init() {
        super.init()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        masksToBounds      = true
        shouldRasterize    = true
        contentsScale      = UIScreen.main.scale
        rasterizationScale = UIScreen.main.scale
        setNeedsDisplay()
    }
    
    override func draw(in ctx: CGContext) {
        ctx.setAllowsAntialiasing(true);
        ctx.setShouldAntialias(true);
        ctx.interpolationQuality = .high;
        let colorspace = CGColorSpaceCreateDeviceRGB();
        
        var rect   = bounds
        var radius = cornerRadius
        if self.borderWidth != 0 {
            rect   = rect.insetBy(dx:borderWidth, dy: borderWidth);
            radius -= borderWidth
            radius = max(radius, 0)
        }
        let someInnerPath: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
        ctx.addPath(someInnerPath)
        ctx.clip()
        
        let shadowPath = CGMutablePath()
        let shadowRect = rect.insetBy(dx: -rect.size.width, dy: -rect.size.width)
        shadowPath.addRect(shadowRect)
        shadowPath.addPath(someInnerPath)
        shadowPath.closeSubpath()
        
        let oldComponents: [CGFloat] = innerShadowColor.components!
        var newComponents:[CGFloat] = [0, 0, 0, 0]
        let numberOfComponents: Int = innerShadowColor.numberOfComponents
        switch (numberOfComponents){
        case 2:
            // 灰度
            newComponents[0] = oldComponents[0]
            newComponents[1] = oldComponents[0]
            newComponents[2] = oldComponents[0]
            newComponents[3] = oldComponents[1] * CGFloat(innerShadowOpacity)
        case 4:
            // RGBA
            newComponents[0] = oldComponents[0]
            newComponents[1] = oldComponents[1]
            newComponents[2] = oldComponents[2]
            newComponents[3] = oldComponents[3] * CGFloat(innerShadowOpacity)
        default: break
        }
        let innerShadowColorWithMultipliedAlpha = CGColor(colorSpace: colorspace, components: newComponents) ?? UIColor.white.cgColor
        ctx.setFillColor(innerShadowColorWithMultipliedAlpha)
        ctx.setShadow(offset: innerShadowOffset, blur: innerShadowRadius, color: innerShadowColorWithMultipliedAlpha)
        ctx.addPath(shadowPath)
        ctx.fillPath()
    }
}
