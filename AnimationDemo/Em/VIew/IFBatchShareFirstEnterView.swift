//
//  IFBatchShareFirstEnterView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/28.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class IFBatchShareFirstEnterView: UIView {
    fileprivate lazy var bgView: UIImageView = {
        let bgView = UIImageView()
        bgView.image = UIImage(named: "ic_batchshare_first_bg")
        return bgView
    }()
    fileprivate lazy var doubleRowView: IFBatchShareFirstDoubleView = {
        let view = IFBatchShareFirstDoubleView()
        view.icon.image = UIImage(named: "ic_batchshare_first_0")
        view.gradientLabel.label.text = "批量分享".localized(nil)
        view.titleLabel.text = "一键分享全部照片".localized(nil)
        view.subtitleLabel.text = "支持高质量下载".localized(nil)
        return view
    }()
    fileprivate lazy var firstRowView0: IFBatchShareFirstOneView = {
        let view = IFBatchShareFirstOneView()
        view.icon.image = UIImage(named: "ic_batchshare_first_1")
        view.gradientLabel.label.text = "极速交付".localized(nil)
        view.titleLabel.text = "省去单张分享烦恼".localized(nil)
        return view
    }()
    fileprivate lazy var firstRowView1: IFBatchShareFirstOneView = {
        let view = IFBatchShareFirstOneView()
        view.icon.image = UIImage(named: "ic_batchshare_first_2")
        view.gradientLabel.label.text = "限时展示照片".localized(nil)
        view.titleLabel.text = "保护你的隐私安全".localized(nil)
        return view
    }()
    fileprivate lazy var btn: UIButton = {
        let btn = UIButton()
        btn.setTitle("好的，去分享".localized(nil), for: .normal)
        btn.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 16)
        btn.setTitleColor(UIColor(hex: 0xe5c9b6), for: .normal)
        btn.backgroundColor = .black
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(doubleRowView)
        addSubview(firstRowView0)
        addSubview(firstRowView1)
        let btnView = UIView()
        addSubview(btnView)
        btnView.addSubview(btn)

        bgView.snp.makeConstraints { $0.edges.equalTo(0) }
        doubleRowView.snp.makeConstraints {
            $0.top.equalTo(UIDevice.current.isiPhoneXSeries ? 84 : 60)
            $0.left.equalTo(33)
            $0.right.equalTo(0)
            $0.height.equalTo(130)
        }
        let sapcing = UIDevice.current.isiPhoneXSeries ? 69.0 : 35
        firstRowView0.snp.makeConstraints {
            $0.left.equalTo(doubleRowView.snp.left)
            $0.right.equalTo(0)
            $0.top.equalTo(doubleRowView.snp.bottom).offset(sapcing)
            $0.height.equalTo(130)
        }
        firstRowView1.snp.makeConstraints {
            $0.top.equalTo(firstRowView0.snp.bottom).offset(sapcing)
            $0.right.equalTo(0)
            $0.left.equalTo(firstRowView0.snp.left)
            $0.height.equalTo(130)
        }
        btnView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(0)
            $0.top.equalTo(firstRowView1.snp.bottom)
        }
        btn.snp.makeConstraints {
            $0.left.equalTo(25)
            $0.right.equalTo(-25)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class IFGradientLabel: UIView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SourceHanSansCN-Heavy", size: 19)
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var gradientView: FXGradientView = {
        let gradientView = FXGradientView()
        let layer = gradientView.layer as? CAGradientLayer
        layer?.colors = [UIColor(hex: 0xffd0af)!.cgColor, UIColor(hex: 0xe7b28d)!.cgColor]
        layer?.startPoint = CGPoint(x: 0, y: 0.5)
        layer?.endPoint = CGPoint(x: 1, y: 0.5)
        return gradientView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(gradientView)
        gradientView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        gradientView.layer.mask = label.layer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.frame = bounds
        label.frame = gradientView.bounds
    }
}

fileprivate
class IFBatchShareFirstDoubleView: UIView {
    fileprivate lazy var gradientLabel: IFGradientLabel = {
        let label = IFGradientLabel()
        return label
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0x4e4e4e)
        label.font = UIFont(name: "PingFangSC-Regular", size: 14)
        return label
    }()
    fileprivate lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0x4e4e4e)
        label.font = UIFont(name: "PingFangSC-Regular", size: 14)
        return label
    }()
    fileprivate lazy var icon: UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        addSubview(icon)
        let view = UIView()
        addSubview(view)
        view.addSubview(gradientLabel)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        gradientLabel.snp.makeConstraints {
            $0.left.top.equalTo(0)
            $0.width.equalTo(200)
            $0.height.equalTo(21)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(gradientLabel.snp.bottom).offset(13)
            $0.height.equalTo(13)
            $0.left.equalTo(gradientLabel.snp.left)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.height.equalTo(13)
            $0.left.equalTo(gradientLabel.snp.left)
            $0.bottom.equalTo(0)
        }
        icon.snp.makeConstraints {
            $0.left.top.equalTo(0)
            $0.size.equalTo(CGSize(width: 148, height: 130))
        }
        view.snp.makeConstraints {
            $0.left.equalTo(icon.snp.right).offset(29)
            $0.centerY.equalTo(icon.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

fileprivate
class IFBatchShareFirstOneView: UIView {
    fileprivate lazy var gradientLabel: IFGradientLabel = {
        let label = IFGradientLabel()
        return label
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0x4e4e4e)
        label.font = UIFont(name: "PingFangSC-Regular", size: 14)
        return label
    }()
    fileprivate lazy var icon: UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        addSubview(icon)
        gradientLabel.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.width.equalTo(200)
        }
     
        addSubview(icon)
        icon.snp.makeConstraints {
            $0.left.top.equalTo(0)
            $0.size.equalTo(CGSize(width: 148, height: 130))
        }
        let stack = UIView()
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.centerY.equalTo(icon.snp.centerY)
            $0.left.equalTo(icon.snp.right).offset(30)
        }
        stack.addSubview(gradientLabel)
        stack.addSubview(titleLabel)
        gradientLabel.snp.makeConstraints {
            $0.left.top.equalTo(0)
            $0.width.equalTo(200)
            $0.height.equalTo(21)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(gradientLabel.snp.left)
            $0.top.equalTo(gradientLabel.snp.bottom).offset(10)
            $0.height.equalTo(13)
            $0.bottom.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


