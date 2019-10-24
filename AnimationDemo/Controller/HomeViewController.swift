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
        let test = ListItem("测试t控制器", handler: { [weak self] in
                  guard let weakSelf = self else {
                                  return
                              }
                  let vcc = TestViewController()
                  weakSelf.navigationController?.pushViewController(vcc, animated: true)
                  })
        //
        items.append(tap)
        items.append(pinch)
        items.append(move)
        items.append(flip)
        items.append(input)
        items.append(pop)
        items.append(test)
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
