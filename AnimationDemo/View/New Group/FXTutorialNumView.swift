//
//  FXTutorialNumView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/4.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation
import UIKit

class FXTutorialNumView: UIView {
    class FXSlashView: UIView {
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            let startPoint = CGPoint(x: 0, y: rect.height)
            let endPoint = CGPoint(x: rect.width, y: 0)
            let path = UIBezierPath()
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            path.lineWidth = 1
            path.lineJoinStyle = .round
            UIColor.white.setStroke()
            path.stroke()
        }
    }
    
    fileprivate lazy var numeratorLabel: UILabel = {
        let numeratorLabel = UILabel()
        numeratorLabel.text = "1"
        numeratorLabel.textColor = UIColor.white
        numeratorLabel.textAlignment = .right
        numeratorLabel.font = UIFont.customFont(ofSize: 11)
        return numeratorLabel
    }()
    fileprivate lazy var denominatorLabel: UILabel = {
        let denominatorLabel = UILabel()
        denominatorLabel.text = "4"
        denominatorLabel.textColor = UIColor.white
        denominatorLabel.font = UIFont.customFont(ofSize: 14)
        denominatorLabel.textAlignment = .left
        return denominatorLabel
    }()
    fileprivate lazy var slashLine: FXSlashView = {
        let slashLine = FXSlashView()
        slashLine.backgroundColor = .clear
        return slashLine
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(slashLine)
        addSubview(numeratorLabel)
        addSubview(denominatorLabel)

        slashLine.snp.makeConstraints {
            $0.center.equalTo(snp.center)
            $0.size.equalTo(CGSize(width: 6, height: 10))
        }
        numeratorLabel.snp.makeConstraints {
            $0.centerY.equalTo(slashLine.snp.centerY)
            $0.right.equalTo(slashLine.snp.centerX).offset(-4)
        }
        denominatorLabel.snp.makeConstraints {
            $0.centerY.equalTo(slashLine.snp.centerY)
            $0.left.equalTo(slashLine.snp.centerX).offset(4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
