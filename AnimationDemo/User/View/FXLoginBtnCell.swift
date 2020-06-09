//
//  FXLoginBtnCell.swift
//  PgImageProEditUISDK
//
//  Created by lieon on 2020/5/28.
//

import RxSwift
import RxCocoa

class FXLoginBtnCell: UITableViewCell {
    var bag = DisposeBag()
    lazy var btn: FXCodeGradientBtn = {
        let btn = FXCodeGradientBtn()
        btn.setTitle("登录", for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 16, isBold: true)
        btn.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
        btn.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .disabled)
        btn.normalShadow()
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(btn)
        
        btn.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(50)
            $0.centerY.equalTo(snp.centerY)
        }
    }
    
    override func prepareForReuse() {
        bag = DisposeBag()
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
