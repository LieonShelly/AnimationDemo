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
        static let titleTop: CGFloat = 4
        static let playerTop: CGFloat = 20
        static let playerBottom: CGFloat = -35 * 0.5
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
            $0.bottom.equalTo(OtherUISize.playerBottom)
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
    
    fileprivate var cornerRadius: CGFloat = 22
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowPath = path
        layer.shadowColor = UIColor(hex: 0x020207)!.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 7)
        layer.shadowRadius = 15
    }
    
}
