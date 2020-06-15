//
//  FXTutorialManulVideoHandleCell.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/15.
//  Copyright © 2020 lieon. All rights reserved.
//  教程技巧Cell

import UIKit

class FXTutorialManulVideoHandleCell: UITableViewCell {
    struct UISize {
        static let playerHorizonInset: CGFloat = UIDevice.current.isiPhoneXSeries ? 50 : 20
    }
    fileprivate lazy var titlelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    fileprivate lazy var playerCoverView: UIImageView = {
        let playerCoverView = UIImageView()
        playerCoverView.layer.cornerRadius = 15
        playerCoverView.layer.masksToBounds = true
        return playerCoverView
    }()
    fileprivate lazy var playerView: FXPlayerView = {
        let playerView = FXPlayerView()
        playerView.layer.cornerRadius = 15
        playerView.layer.masksToBounds = true
        return playerView
    }()
    fileprivate lazy var shadowView: UIView = {
        let shadowView = UIView()
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 8)
        shadowView.layer.shadowColor = UIColor.red.cgColor //UIColor(hex: 0x020207)!.cgColor
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 23
        return shadowView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(titlelabel)
        contentView.addSubview(shadowView)
        contentView.addSubview(playerView)
        contentView.addSubview(playerCoverView)
        titlelabel.snp.makeConstraints {
            $0.top.equalTo(4)
            $0.left.equalTo(10)
            $0.right.equalTo(-10)
        }
        playerView.snp.makeConstraints {
            $0.top.equalTo(titlelabel.snp.bottom).offset(20)
            $0.left.equalTo(UISize.playerHorizonInset)
            $0.right.equalTo(-UISize.playerHorizonInset)
            $0.bottom.equalTo(-35 * 0.5)
            $0.height.equalTo(100)
        }
        shadowView.snp.makeConstraints {
            $0.edges.equalTo(playerView.snp.edges).inset(-5)
        }
        playerCoverView.snp.makeConstraints {
            $0.edges.equalTo(playerView.snp.edges)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FXTutorialManulVideoHandleCell {
    func configData(_ model: FXTutorialHandleVideoModel) {
        titlelabel.text = model.text
        if let videoUrl = model.videoURL {
            FXVideoCoverGenerator.shared.generateThumbnailForVideo(videoUrl) { (image, url) in
                if videoUrl.absoluteString == url.absoluteString {
                    self.playerCoverView.image = image
                }
            }
            let imageHeight = FXTutorialHandleVideoListVC.playerHeight(videoUrl, relativeWidth: bounds.width - UISize.playerHorizonInset * 2)
            playerView.snp.updateConstraints {
                $0.height.equalTo(imageHeight)
            }
        }
    }
}
