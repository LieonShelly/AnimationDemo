//
//  FXTutoriaComonSkillVideoCell.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/15.
//  Copyright © 2020 lieon. All rights reserved.
//  通用技巧cell

import Foundation

class FXTutoriaComonSkillVideoCell: FXTutorialManulVideoBaseCell {
    
    struct OtherUISize {
        static let titleBgHeigt: CGFloat = 87
    }
    
    fileprivate lazy var titlelBg: BlurImageView = {
        let view = BlurImageView()
        view.visualEffectView.tint(UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1), blurRadius: 20, colorTintAlpha: 0.4)
        return view
    }()
    
    fileprivate lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        return containerView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        playerView.layer.cornerRadius = 0
        playerCoverView.layer.cornerRadius = 0
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(shadowView)
        contentView.addSubview(containerView)
        containerView.addSubview(titlelBg)
        containerView.addSubview(titlelabel)
        containerView.addSubview(playerView)
        containerView.addSubview(playerCoverView)
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(35 * 0.5)
            $0.bottom.equalTo(-35 * 0.5)
            $0.height.equalTo(300)
            $0.left.equalTo(UISize.playerHorizonInset)
            $0.right.equalTo(-UISize.playerHorizonInset)
        }
        titlelBg.snp.makeConstraints {
            $0.left.right.bottom.equalTo(0)
            $0.height.equalTo(OtherUISize.titleBgHeigt)
        }
        titlelabel.snp.makeConstraints {
            $0.center.equalTo(titlelBg.snp.center)
            $0.left.equalTo(30)
            $0.right.equalTo(-30)
        }
        playerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.left.equalTo(0)
            $0.right.equalTo(0)
            $0.bottom.equalTo(titlelBg.snp.top)
        }
        shadowView.snp.makeConstraints {
            $0.edges.equalTo(containerView.snp.edges).inset(-0)
        }
        playerCoverView.snp.makeConstraints {
            $0.edges.equalTo(playerView.snp.edges)
        }
    }
    
    override func configData(_ model: FXTutorialHandleVideoModel) {
        titlelabel.text = model.text
        if let videoUrl = model.videoURL {
            let imageWidth = UIScreen.main.bounds.width - UISize.playerHorizonInset * 2
            let imageHeight = FXTutorialHandleVideoListVC.playerHeight(videoUrl, relativeWidth: imageWidth)
            let containerH = imageHeight + OtherUISize.titleBgHeigt
            if containerH != containerView.bounds.height {
                containerView.snp.updateConstraints {
                    $0.height.equalTo(containerH)
                }
                contentView.layoutIfNeeded()
            }
            if let cover = model.coverImg {
                let image = UIImage(contentsOfFile: cover)
                self.playerCoverView.image = image
                self.titlelBg.image = image
            } else {
                FXVideoCoverGenerator.shared.generateThumbnailForVideo(videoUrl, maximumSize: CGSize(width: imageWidth, height: imageHeight)) { (image, url) in
                    if videoUrl.absoluteString == url.absoluteString {
                        self.playerCoverView.image = image
                        self.titlelBg.image = image
                    }
                }
            }
        }
        startPlay(model)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
