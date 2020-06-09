//
//  FXLoginTextInputCell.swift
//  PgImageProEditUISDK
//
//  Created by lieon on 2020/5/28.
//

import RxSwift
import RxCocoa

class FXLoginTextInputCell: UITableViewCell {
    var bag = DisposeBag()
    fileprivate lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        return line
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Text"
        label.textColor = .black
        label.font = UIFont.customFont(ofSize: 14, isBold: true)
        label.textAlignment = .left
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.textColor = .black
        textField.font = UIFont.customFont(ofSize: 14, isBold: true)
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.bottom.equalTo(0)
            $0.height.equalTo(0.5)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.centerY.equalTo(snp.centerY)
        }
        textField.snp.makeConstraints {
            $0.right.equalTo(-20)
            $0.height.equalTo(50)
            $0.centerY.equalTo(snp.centerY).offset(1)
            $0.left.equalTo(titleLabel.snp.right).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
