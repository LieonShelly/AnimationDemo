//
//  IFMyShareAlbumDetailTimeLineView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/22.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class IFMyShareAlbumDetailTimeLineView: UIView {
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 12)
        label.textColor = UIColor.white
        label.alpha = 0.2
        let attr0 = NSMutableAttributedString(string: "COUNT")
        attr0.addAttributes([.font: UIFont(name: "PingFangSC-Light", size: 12)!,
                             .foregroundColor: UIColor.white,
                             .kern: 1.5],
                            range: NSRange(location: 0, length: attr0.string.count))
        attr0.append(NSAttributedString(string: " "))
        
        let attr1 = NSMutableAttributedString(string: "DOWN")
        attr1.addAttributes([.font: UIFont(name: "PingFangSC-Light", size: 12)!,
                             .foregroundColor: UIColor.white,
                             .kern: 1.5],
                            range: NSRange(location: 0, length: attr1.string.count))
        attr0.append(attr1)
        label.attributedText = attr0
        return label
    }()
    fileprivate lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Light", size: 16)
        label.textColor = UIColor(hex: 0xeccbb5)
        label.text = "距离分享结束还有".localized(nil)
        return label
    }()
    fileprivate lazy var hourView: IFMyShareAlbumDetailTimeView = {
        let view = IFMyShareAlbumDetailTimeView()
        return view
    }()
    fileprivate lazy var minuteView: IFMyShareAlbumDetailTimeView = {
        let view = IFMyShareAlbumDetailTimeView()
        return view
    }()
    fileprivate lazy var secondView: IFMyShareAlbumDetailTimeView = {
        let view = IFMyShareAlbumDetailTimeView()
        return view
    }()
    fileprivate var timer: DispatchSourceTimer?
    fileprivate var timeInterval = 0
    fileprivate lazy var foreView: UIImageView = {
        let foreView = UIImageView()
        return foreView
    }()
    fileprivate lazy var stack: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        hourView.config("\(String(format: "%02d", 0))", subTitle: "时")
        minuteView.config("\(String(format: "%02d", 0))", subTitle: "分")
        secondView.config("\(String(format: "%02d", 0))", subTitle: "秒")
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(hourView)
        addSubview(minuteView)
        addSubview(secondView)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.top.equalTo(0)
            $0.height.equalTo(17)
        }
        subtitleLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.top.equalTo(titleLabel.snp.bottom).offset(1)
            $0.height.equalTo(22)
        }
        stack.addArrangedSubview(hourView)
        stack.addArrangedSubview(minuteView)
        stack.addArrangedSubview(secondView)
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        hourView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 53 + 5 + 12, height: 52))
        }
        minuteView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 53 + 5 + 12, height: 52))
        }
        secondView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 53 + 5 + 12, height: 52))
        }
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func config(_ timeInterval: Int) {
        self.timeInterval = timeInterval
        if let timer = self.timer {
            timer.cancel()
        }
        let timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.init(rawValue: 0), queue: DispatchQueue.main)
        timer.schedule(deadline: DispatchTime.now(), repeating: 1)
        timer.setEventHandler { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.timeInterval -= 1
            if weakSelf.timeInterval < 0 {
                weakSelf.timer?.cancel()
                return
            }
            let hor = weakSelf.timeInterval % (24 * 3600) / 3600
            let min = weakSelf.timeInterval % 3600 / 60
            let sec = weakSelf.timeInterval % 60
            weakSelf.hourView.config("\(String(format: "%02d", hor))", subTitle: "时")
            weakSelf.minuteView.config("\(String(format: "%02d", min))", subTitle: "分")
            weakSelf.secondView.config("\(String(format: "%02d", sec))", subTitle: "秒")
        }
        timer.resume()
        self.timer = timer
    }
    
    deinit {
        self.timer?.cancel()
    }
}

