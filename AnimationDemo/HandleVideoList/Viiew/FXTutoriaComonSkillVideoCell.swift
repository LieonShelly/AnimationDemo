//
//  FXTutoriaComonSkillVideoCell.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/15.
//  Copyright © 2020 lieon. All rights reserved.
//  通用技巧cell

import Foundation

class FXTutoriaComonSkillVideoCell: UITableViewCell {
    struct UISize {
        static let playerHorizonInset: CGFloat = UIDevice.current.isiPhoneXSeries ? 50 : 20
        static let titleBgHeigt: CGFloat = 87
    }
    fileprivate lazy var titlelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    fileprivate lazy var titlelBg: BlurImageView = {
        let view = BlurImageView()
        view.visualEffectView.tint(UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1), blurRadius: 20, colorTintAlpha: 0.4)
        return view
    }()
    fileprivate lazy var playerCoverView: UIImageView = {
        let playerCoverView = UIImageView()
        return playerCoverView
    }()
    fileprivate lazy var playerView: FXPlayerView = {
        let playerView = FXPlayerView()
        return playerView
    }()
    fileprivate lazy var shadowView: FXShadowView = {
        let shadowView = FXShadowView()
        return shadowView
    }()
    fileprivate lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        return containerView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
            $0.height.equalTo(UISize.titleBgHeigt)
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
            $0.height.equalTo(100)
        }
        shadowView.snp.makeConstraints {
            $0.edges.equalTo(containerView.snp.edges).inset(-0)
        }
        playerCoverView.snp.makeConstraints {
            $0.edges.equalTo(playerView.snp.edges)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FXTutoriaComonSkillVideoCell {
    func configData(_ model: FXTutorialHandleVideoModel) {
        titlelabel.text = model.text
        if let videoUrl = model.videoURL {
            FXVideoCoverGenerator.shared.generateThumbnailForVideo(videoUrl) { (image, url) in
                if videoUrl.absoluteString == url.absoluteString {
                    self.playerCoverView.image = image
                    self.titlelBg.image = image
                }
            }
            let imageHeight = FXTutorialHandleVideoListVC.playerHeight(videoUrl, relativeWidth: UIScreen.main.bounds.width - UISize.playerHorizonInset * 2)
            containerView.snp.updateConstraints {
                $0.height.equalTo(imageHeight + UISize.titleBgHeigt)
            }
        }
    }
}
