//
//  ProgressAnimation.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/11.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit


class ProgressView: UIView {
    fileprivate lazy var progressLabel: UILabel = {
        let progressLabel = UILabel()
        progressLabel.text = "0.0%"
        progressLabel.font = UIFont.boldSystemFont(ofSize: 15)
        progressLabel.textColor = UIColor.yellow
        return progressLabel
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
           let progressLabel = UILabel()
           progressLabel.text = "name"
           progressLabel.font = UIFont.boldSystemFont(ofSize: 15)
           progressLabel.textColor = UIColor.black
           return progressLabel
    }()
    
    fileprivate lazy var circleLayer: CAShapeLayer = {
        let circleLayer = CAShapeLayer()
        circleLayer.lineWidth = 10
        circleLayer.lineJoin = .round
        circleLayer.lineCap = .butt
        return circleLayer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }
}

extension ProgressView {
    fileprivate func configUI() {
        addSubview(progressLabel)
        addSubview(nameLabel)
        layer.addSublayer(circleLayer)
    }
    
    fileprivate func layout() {
        let nameLabelH: CGFloat = 40
        let progressLabelCenterX = progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        let progressLabelCenterY = progressLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: nameLabelH)
        NSLayoutConstraint.activate([progressLabelCenterY, progressLabelCenterX])
        
        let nameLabelCenterX = nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        let nameLabelBottom = nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([nameLabelCenterX, nameLabelBottom])
        
        circleLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - nameLabelH)
        
    }
}
