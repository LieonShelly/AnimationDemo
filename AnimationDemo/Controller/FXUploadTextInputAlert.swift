//
//  FXUploadTextInputAlert.swift
//  PgImageProEditUISDK
//
//  Created by lieon on 2020/6/9.
//

import UIKit
import RxSwift
import RxCocoa

class FXUploadTextInputAlert: UIViewController {
    var textCallback: ((String) -> Void)?
    let bag = DisposeBag()
    fileprivate lazy var textView: FXUploadTextView = {
        let textView = FXUploadTextView()
        textView.layer.borderColor = UIColor.black.withAlphaComponent(0.7).cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5
        textView.returnKeyType = .done
        textView.font = UIFont.customFont(ofSize: 17)
        return textView
    }()
    
    fileprivate lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray.withAlphaComponent(0.8)
        label.font = UIFont.customFont(ofSize: 17, isBold: false)
        label.text = "placeHolder"
        return label
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.text = "title"
        titleLabel.font = UIFont.customFont(ofSize: 20, isBold: true)
        return titleLabel
    }()
    fileprivate lazy var cancleBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 20, isBold: true)
        return btn
    }()
    fileprivate lazy var enterBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 20, isBold: true)
        return btn
    }()
    fileprivate lazy var btnContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    fileprivate lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    fileprivate lazy var horsionLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return line
    }()
    fileprivate lazy var verticalLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return line
    }()
    fileprivate lazy var coverBtn: UIButton = {
        let coverBtn = UIButton()
        coverBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return coverBtn
    }()
    
    fileprivate var contentViewHeight: CGFloat = 0
    
    convenience init(_ title: String? = nil, textLimit: Int, inputText: String?, callback: ((String) -> Void)?) {
        self.init()
        self.textCallback = callback
        if let text = inputText {
            textView.text = text
        }
        titleLabel.text = title
        placeholderLabel.text = "请输入\(textLimit)个字符以内的文本"
        let textView = self.textView
        textView.rx.text.orEmpty.map { (text) -> String? in
            if  textView.markedTextRange != nil {
                return nil
            }
            if text.count >= textLimit {
                return String(text[..<text.index(text.startIndex, offsetBy: textLimit)])
            }
            return text
        }
        .filter { $0 != nil }
        .bind(to: textView.rx.text)
        .disposed(by: bag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
}

extension FXUploadTextInputAlert {
    fileprivate func configUI() {
        let titleTop: CGFloat = 20
        let titleHeight: CGFloat = 40
        let textViewTop: CGFloat = 15
        let textViewHeight: CGFloat = 100
        let textViewBottom: CGFloat = 15
        let btnContainerHeight: CGFloat = 55
        view.backgroundColor = .clear
        coverBtn.frame = view.bounds
        view.addSubview(coverBtn)
        view.addSubview(contentView)
        view.addSubview(titleLabel)
        view.addSubview(textView)
        view.addSubview(placeholderLabel)
        contentView.addSubview(btnContainer)
        btnContainer.addSubview(cancleBtn)
        btnContainer.addSubview(enterBtn)
        btnContainer.addSubview(horsionLine)
        btnContainer.addSubview(verticalLine)

        contentView.snp.makeConstraints {
            $0.right.equalTo(-25)
            $0.left.equalTo(25)
            $0.centerY.equalTo(view.snp.centerY).offset(0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(titleTop)
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.height.equalTo(titleHeight)
        }
      
        btnContainer.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left)
            $0.right.equalTo(contentView.snp.right)
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.height.equalTo(btnContainerHeight)
        }
        cancleBtn.snp.makeConstraints {
            $0.left.bottom.top.equalTo(0)
            $0.width.equalTo(btnContainer.snp.width).multipliedBy(0.5)
        }
        enterBtn.snp.makeConstraints {
            $0.right.bottom.top.equalTo(0)
            $0.width.equalTo(btnContainer.snp.width).multipliedBy(0.5)
        }
        horsionLine.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.left.right.top.equalTo(0)
        }
        verticalLine.snp.makeConstraints {
            $0.top.bottom.equalTo(0)
            $0.centerX.equalTo(btnContainer.snp.centerX)
            $0.width.equalTo(0.5)
        }
        
        textView.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left).offset(10)
            $0.right.equalTo(contentView.snp.right).offset(-10)
            $0.height.equalTo(textViewHeight)
            $0.top.equalTo(titleLabel.snp.bottom).offset(titleTop)
            $0.bottom.equalTo(btnContainer.snp.top).offset(-textViewBottom)
        }
        placeholderLabel.snp.makeConstraints {
            $0.left.equalTo(textView.snp.left).offset(5)
            $0.top.equalTo(textView.snp.top).offset(8)
        }
        
        cancleBtn.rx.tap
            .subscribe(onNext: { (_) in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
        contentViewHeight = titleTop + titleHeight + textViewTop + textViewHeight + textViewBottom + btnContainerHeight
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
            self.textView.becomeFirstResponder()
        }
        textView.delegate = self
        
        enterBtn.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let weakSelf = self else {
                    return
                }
                if !weakSelf.textView.text.isEmpty {
                    weakSelf.textCallback?(weakSelf.textView.text)
                }
                weakSelf.dismiss(animated: true, completion: nil)
            })
        .disposed(by: bag)

    }
    
    @objc
    fileprivate func keyboardWillChangeFrame(_ note: Notification) {
        guard let endFrame = note.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
            return
        }
        let inset: CGFloat = 20
        let endY = view.bounds.height * 0.5 + contentViewHeight * 0.5
        if endY < endFrame.origin.y {
            return
        }
        let delta = endY - endFrame.origin.y + inset
        contentView.snp.updateConstraints {
            $0.centerY.equalTo(view.snp.centerY).offset(-delta)
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension FXUploadTextInputAlert: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}


class FXUploadTextView: UITextView {
 
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
            return true
        }
        return false
    }
    
}

class FXUploadInputText {
    var text: String
    var mark: String?
    
    init(text: String) {
        self.text = text
    }
}
