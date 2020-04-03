//
//  FXTutorialUploadProgressView.swift
//  PgImageProEditUISDK
//
//  Created by lieon on 2020/3/26.
//

import Foundation
import UIKit


class FXTutorialUploadProgressView: UIView {
    fileprivate lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.color = UIColor.systemBlue
        return activityView
    }()
    fileprivate lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return coverView
    }()
    
    fileprivate lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.transform = CGAffineTransform(scaleX: 1, y: 2)
        return progressView
    }()
    
    
    
    fileprivate lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.customFont(ofSize: 15, isBold: true)
        descLabel.textAlignment = .center
        descLabel.textColor = UIColor.white
        return descLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverView)
        addSubview(progressView)
        addSubview(descLabel)
        addSubview(activityView)
        coverView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        progressView.snp.makeConstraints {
            $0.bottom.equalTo(snp.centerY)
            $0.width.equalTo(300)
            $0.centerX.equalTo(snp.centerX)
        }
        descLabel.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.right.equalTo(-10)
            $0.top.equalTo(progressView.snp.bottom).offset(5)
        }
        activityView.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.bottom.equalTo(progressView.snp.top).offset(-5)
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        superview?.willMove(toSuperview: newSuperview)
        activityView.startAnimating()
    }
    
    func show(_ text: String) {
        descLabel.text = text
    }
    
    func updateProgress(_ progress: Float) {
        progressView.setProgress(progress, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
