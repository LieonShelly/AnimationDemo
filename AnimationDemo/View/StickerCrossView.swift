//
//  StickerCrossView.swift
//  PgImageProEditUISDK
//
//  Created by lieon on 2020/7/20.
//  素材十字中心线的框

import UIKit

class StickerCrossView: UIView {
    struct UISize {
        // 按照垂直方向规定宽和高
        static let lineW: CGFloat = 2
        static let lineH: CGFloat = 28
        static let minLength: CGFloat = 85
    }
    fileprivate lazy var lineTop: StickerCrossLine = {
        let line = StickerCrossLine()
        return line
    }()
    fileprivate lazy var lineRight: StickerCrossLine = {
        let line = StickerCrossLine()
        return line
    }()
    fileprivate lazy var lineBottom: StickerCrossLine = {
        let line = StickerCrossLine()
        return line
    }()
    fileprivate lazy var lineLeft: StickerCrossLine = {
        let line = StickerCrossLine()
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineTop)
        addSubview(lineRight)
        addSubview(lineBottom)
        addSubview(lineLeft)
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let length = min(bounds.width, bounds.height)
        if length <= UISize.minLength {
            lineTop.frame = CGRect(x:(bounds.width - UISize.lineW) * 0.5, y: -UISize.lineH, width: UISize.lineW, height: UISize.lineH)
            lineRight.frame = CGRect(x: bounds.width, y: bounds.height * 0.5 - UISize.lineW * 0.5, width: UISize.lineH, height: UISize.lineW)
            lineBottom.frame = CGRect(x: (bounds.width - UISize.lineW) * 0.5, y: bounds.height, width: UISize.lineW, height:  UISize.lineH)
            lineLeft.frame = CGRect(x: -UISize.lineH, y: bounds.height * 0.5 - UISize.lineW * 0.5, width:  UISize.lineH, height: UISize.lineW)
        } else {
            lineTop.frame = CGRect(x:(bounds.width - UISize.lineW) * 0.5, y: 0, width: UISize.lineW, height: UISize.lineH)
            lineRight.frame = CGRect(x: bounds.width - UISize.lineH, y: bounds.height * 0.5 - UISize.lineW * 0.5, width: UISize.lineH, height: UISize.lineW)
            lineBottom.frame = CGRect(x: (bounds.width - UISize.lineW) * 0.5, y: bounds.height - UISize.lineH, width: UISize.lineW, height:  UISize.lineH)
            lineLeft.frame = CGRect(x: 0, y: bounds.height * 0.5 - UISize.lineW * 0.5, width:  UISize.lineH, height: UISize.lineW)
        }
      
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


class StickerCrossLine: UIView {
    fileprivate lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = .white
        line.layer.masksToBounds = true
        return line
    }()
    
    fileprivate lazy var shaderView: IFShadowView = {
        let shaderView = IFShadowView()
        shaderView.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        shaderView.shadowOpacity = 1
        shaderView.shadowOffset = CGSize(width: 0, height: 1)
        shaderView.shadowRadius = 2
        return shaderView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(shaderView)
        addSubview(line)
        shaderView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        line.snp.makeConstraints{
            $0.edges.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let corRadius = min(bounds.width, bounds.height) * 0.5
        line.layer.cornerRadius = corRadius
        shaderView.cornerRadius = corRadius
        shaderView.setNeedsLayout()
    }
}

