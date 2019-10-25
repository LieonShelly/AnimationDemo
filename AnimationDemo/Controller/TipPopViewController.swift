//
//  TipPopViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/22.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class TipPopViewController: UIViewController {
    @IBOutlet weak var popHeight: UITextField!
    @IBOutlet weak var popWidth: UITextField!
    @IBOutlet weak var popCornor: UITextField!
    @IBOutlet weak var arrowHeight: UITextField!
    @IBOutlet weak var arrowWidth: UITextField!
    fileprivate var selectedBtn: UIButton?
    fileprivate lazy var param: CommonTipPopParam = CommonTipPopParam()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: view)
        param.arrowPosition = location!
        TipPop.show(param)
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        selectedBtn?.isSelected = false
        sender.isSelected = true
        selectedBtn = sender
        param.direction = ArrowDirection(rawValue: sender.tag) ?? .top
    }
    
    @IBAction func manyPopBtnAction(_ sender: Any) {
        var params: [TipPopParam] = []
        for index in stride(from: 80, to: view.bounds.height, by: 50) {
            let location = CGPoint(x: 40, y: index + 10)
            var param = CommonTipPopParam()
            param.direction = .left
            param.popSize = CGSize(width: 50, height: 50)
            param.arrowPosition = location
            param.textParam = nil
            let customView = UIView()
            customView.backgroundColor = .purple
            param.displayView = customView
            params.append(param)
        }
        TipPop.show(params)
    }
    
    @IBAction func customViewAction(_ sender: UIButton) {
        getSettingValue()
        let location = sender.center
        param.textParam = nil
        param.arrowPosition = location
        let customView = UIView()
//        customView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        customView.backgroundColor = .purple
        param.displayView = customView
        TipPop.show(param)
    }
    
    @IBAction func textTypeBtnAction(_ sender: UIButton) {
        getSettingValue()
        var textParam = CommonTipPopTextParam()
        textParam.backgroudColor = UIColor.clear
        textParam.textColor = .black
        textParam.font = UIFont.systemFont(ofSize: 13)
        textParam.text = "asdhfjha阿萨德发挥世纪东方就按时 氨甲环酸的规范化静安寺鬼地方个家哈"
        param.textParam = textParam
        param.arrowPosition = sender.center
        param.displayView = nil
        TipPop.show(param)
    }
}

extension TipPopViewController {
    
    fileprivate func getSettingValue() {
          let popWidth = Float(self.popWidth!.text ?? "0")
          let popHeight = Float(self.popHeight!.text ?? "0")
          let popCornor = Float(self.popCornor!.text ?? "0")
          let arrowHeight = Float(self.arrowHeight!.text ?? "0")
          let arrowWidth = Float(self.arrowWidth!.text ?? "0")
          param.arrorwSize = CGSize(width: CGFloat(arrowWidth!),
                                    height: CGFloat(arrowHeight!))
          param.cornorRadius = CGFloat(popCornor!)
          param.popSize = CGSize(width: CGFloat(popWidth!),
                                 height: CGFloat(popHeight!))
      }
      
}
