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
    fileprivate lazy var items: [ListItem] = {
        let tap = ListItem("点击类", destVC: TapAnimationViewController())
        let pinch = ListItem("捏合类", destVC: PinchViewController())
        let move = ListItem("移动类", destVC: PanViewController())
        return [tap, pinch, move]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "动画列表"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassWithCell(UITableViewCell.self)
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

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcc = items[indexPath.row].destVC
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(vcc, animated: true)
    }
}

class ListItem {
    var name: String
    var destVC: UIViewController
    
    init(_ name: String, destVC: UIViewController) {
        self.name = name
        self.destVC = destVC
        self.destVC.title = name
    }
}
