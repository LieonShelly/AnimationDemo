//
//  FX3dLightMessageView.swift
//  PgImageProEditUISDK
//
//  Created by lieon on 2020/10/9.
//

import Foundation

class FX3dLightMessageView: UIView {
    fileprivate lazy var  titleLabel: UILabel = {
        let lab = UILabel.init()
        lab.textAlignment = .center
        lab.font = UIFont.customFont(ofSize: 24)
        lab.textColor = .white
        lab.text = "形状光暂时不支持多人脸哦".localized_FX()
        return lab
    }()
    
    fileprivate lazy var subTitleLabel: UILabel = {
        let lab = UILabel.init()
        lab.textAlignment = .center
        lab.font = UIFont.customFont(ofSize: 12)
        lab.textColor = .white
        lab.text = "试试其他光线吧".localized_FX()
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stack = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 6
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}



