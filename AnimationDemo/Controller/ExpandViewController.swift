//
//  ExpandViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/4/25.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class ExpandViewController: UIViewController {
    fileprivate lazy var expandView: ExpandView = {
        let expandView = ExpandView()
        expandView.backgroundColor = .yellow
        expandView.clipsToBounds = true
        return expandView
    }()
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    fileprivate lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .black
        return headerView
    }()
    
    fileprivate lazy var testView: UIView = {
        let testView = UIView()
        testView.backgroundColor = .orange
        return testView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        expandView.frame = self.view.bounds
        expandView.textLabel.font = UIFont.customFont(ofSize: 20, isBold: true)
        self.expandView.imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 400)
        self.expandView.textLabel.frame = CGRect(x: 0, y: 400, width: self.view.bounds.width, height: 20)
         tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassWithCell(UITableViewCell.self)
        view.addSubview(tableView)
//        view.addSubview(expandView)
        testView.frame = CGRect(x: 40, y: view.center.y + 100, width: 100, height: 100)
        view.addSubview(testView)
        headerView.frame =  CGRect(x: 0, y: navigationController!.navigationBar.frame.maxY, width: self.view.bounds.width, height: 400)
        view.addSubview(headerView)
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
}


extension ExpandViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = "cellForRowAt: \(indexPath.row)"
        if indexPath.row == 0 {
            cell.imageView?.image = UIImage(named: "effect_girl")
        } else {
            cell.imageView?.image = nil
        }
        return cell
    }
    
}
extension ExpandViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        cell?.alpha = 0
        UIView.animate(withDuration: 4, animations: {
            self.tableView.transform = CGAffineTransform(scaleX: self.testView.frame.width / self.tableView.bounds.width, y: self.testView.frame.height / self.tableView.bounds.height )
            self.tableView.center = self.testView.center
            self.headerView.frame = self.testView.frame
        }, completion: { _ in
            
        })
    }
}


class ExpandView: UIView {
     lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
     lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .black
        textLabel.isHidden = false
        textLabel.text = "adsfakadhfjahsdfasjkdfhkjasdhfjkasdfhkjasdhfjkashjkdfhkasfhjkashdjajksdfhjkashdfjahsdjkfhaskjdfhkjasdhfkjsadfhkjhfaskjdfhjas"
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(textLabel)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
