//
//  EmptyViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/24.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class EmptyViewController: UIViewController {
    
    fileprivate lazy var exceptionView: IFExceptionView = {
        let emptyView = IFExceptionView()
        return emptyView
    }()
    fileprivate lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    fileprivate lazy var wechatImg: IFMyShareWechatView = {
        let wechatImg = IFMyShareWechatView()
        return wechatImg
    }()
    
    fileprivate var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(wechatImg)
        wechatImg.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        navigationController?.popViewController(animated: true)
        wechatImg.snapShotImage()
    }
}

extension EmptyViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}

extension EmptyViewController: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        if label == nil {
            label = UILabel()
            label?.textColor = .yellow
            label?.textAlignment = .center
            label?.font = UIFont.systemFont(ofSize: 15)
        }
        label?.text = "asdf"
        label?.backgroundColor = .blue
        if let subViews = label?.superview?.superview?.subviews {
            for subView in subViews {
                print(subView)
            }
        }
        return  label!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let  view = self.pickerView(pickerView, viewForRow: row, forComponent: component, reusing: nil)
        view.backgroundColor = .red
        view.isHidden = true
    }
}
