//
//  GuideStartView.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/29.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class GuideStartView: UIView {
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var prepareBtn: UIButton!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var stepLabelHeight: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    static func show() {
        let view = GuideStartView.loadView()
        view.frame = keyWindow.bounds
        view.backgroundColor = .clear
        keyWindow.addSubview(view)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        removeFromSuperview()
    }
    
    static func loadView() -> GuideStartView {
        guard let view = Bundle.main.loadNibNamed("GuideStartView", owner: nil, options: nil)?.first as? GuideStartView else {
            return GuideStartView()
        }
        return view
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


extension GuideStartView {
    fileprivate func configUI() {
        backgroundColor = .clear
        stepLabel.layer.cornerRadius = 10
        stepLabel.layer.masksToBounds = true
        let pargraph = NSMutableParagraphStyle()
        pargraph.alignment = .left
        pargraph.lineBreakMode = .byWordWrapping
        pargraph.lineSpacing = 10

        let text = NSMutableAttributedString()
        let titileAttr = NSMutableAttributedString(string: " 步骤解析:\n")
        titileAttr.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
                                  NSAttributedString.Key.foregroundColor: UIColor.black,
                                  NSMutableAttributedString.Key.paragraphStyle: pargraph],
                                 range: NSRange(location: 0, length: titileAttr.string.count))
        let contentAttr = NSMutableAttributedString(string: " 1.阿斯顿发送到发\n 2.阿萨德发到付打首付款交啊\n 3.阿萨德发到付打首付款交啊\n 4.阿萨德发到付打首付款交啊\n 5.阿萨德发到付打首付款交啊\n\r")
        contentAttr.setAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                                   NSAttributedString.Key.foregroundColor: UIColor.black,
                                   NSMutableAttributedString.Key.paragraphStyle: pargraph],
                                  range: NSRange(location: 0, length: contentAttr.string.count))
        text.append(titileAttr)
        text.append(contentAttr)
        stepLabel.attributedText = text
        stepLabelHeight.constant = text.boundingRect(with: CGSize(width: bounds.width - 120, height: CGFloat.infinity), options: .usesLineFragmentOrigin, context: nil).height
    }
}
