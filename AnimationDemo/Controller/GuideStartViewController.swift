//
//  GuideStartViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/29.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class GuideStartViewController: UIViewController {
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var prepareBtn: UIButton!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var stepLabelHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
}
extension GuideStartViewController {
    fileprivate func configUI() {
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
        stepLabelHeight.constant = text.boundingRect(with: CGSize(width: view.bounds.width - 120, height: CGFloat.infinity), options: .usesLineFragmentOrigin, context: nil).height
    }
}
