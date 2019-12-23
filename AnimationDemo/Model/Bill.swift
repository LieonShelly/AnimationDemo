//
//  Bill.swift
//  AnimationDemo
//
//  Created by lieon on 2019/12/23.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

enum BillCategory: Int {
    case none = -1
    case liveActtivity
    case work
    case transform
    case game
    case study
}

enum DataStatus: Int {
    case normal = 0
    case delete
}

class Bill: Object {
    @objc dynamic var name: String?
    @objc dynamic var date: Double = Date().timeIntervalSince1970
    @objc dynamic var createDate: Double = Date().timeIntervalSince1970
    @objc dynamic var amount: Double = 0
    @objc dynamic var note: String?
    @objc dynamic var status: NSInteger = DataStatus.normal.rawValue
    @objc dynamic var category: NSInteger = BillCategory.none.rawValue
}

extension Bill: Storable {
    
}
