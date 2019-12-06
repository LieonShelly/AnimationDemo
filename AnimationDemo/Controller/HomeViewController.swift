//
//  HomeViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    fileprivate lazy var items: [ListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        return cell
    }
}

extension HomeViewController {
    
    fileprivate func setupUI() {
        title = "动画列表"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassWithCell(UITableViewCell.self)
        let tap = ListItem("点击类", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = TapAnimationViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let pinch = ListItem("捏合类", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = PinchViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let move = ListItem("移动类", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = PanViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let flip = ListItem("VC翻转类", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = FlipViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let input = ListItem("多语言文本输入框", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            MultiLanguageTexInputAlert.show(weakSelf)
        })
        let pop = ListItem("提示气泡", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = TipPopViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let test = ListItem("测试控制器", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = TestViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let btn = ListItem("按钮类", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = BtnViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        
        let press = ListItem("长按放大图片", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = LongPressViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let touch = ListItem("互动教程模拟", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = DemoTouchViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let record = ListItem("互动教程模拟", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = ScreenRecordViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let banner = ListItem("Banner", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = BannerViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let progress = ListItem("SLider", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = ProgressViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let BLur = ListItem("BLur", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = FlurViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let customViewController = ListItem("BLur", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = CustomViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        let btnProgressViewController = ListItem("ProgressBtn", handler: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let vcc = BtnProgressViewController()
            weakSelf.navigationController?.pushViewController(vcc, animated: true)
        })
        
        let playerViewController = ListItem("player", handler: { [weak self] in
              guard let weakSelf = self else {
                  return
              }
              let vcc = PlayerViewController()
              weakSelf.navigationController?.pushViewController(vcc, animated: true)
          })
        items.append(tap)
        items.append(pinch)
        items.append(move)
        items.append(flip)
        items.append(input)
        items.append(pop)
        items.append(test)
        items.append(btn)
        items.append(press)
        items.append(touch)
        items.append(record)
        items.append(banner)
        items.append(progress)
        items.append(BLur)
        items.append(customViewController)
        items.append(btnProgressViewController)
        items.append(playerViewController)
    }
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let handler = items[indexPath.row].handler
        handler?()
    }
}

class ListItem {
    var name: String
    var handler: (() -> Void)?
    
    init(_ name: String, handler: (() -> Void)?) {
        self.name = name
        self.handler = handler
    }
}
