//
//  Protocol.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit



public struct Sorted {
    var key: String
    var ascending: Bool = true
}

protocol StorageContext {
   
    associatedtype DBEntityType
    
    func create(_ model: DBEntityType) -> DBEntityType?

    func save(object: DBEntityType) throws

    func saveAll(objects: [DBEntityType]) throws

    func update(object: DBEntityType) throws

    func delete(object: DBEntityType) throws

    func deleteAll(_ model: DBEntityType.Type) throws

    func fetch(_ model: DBEntityType.Type, predicate: NSPredicate?, sorted: Sorted?, page: Int, num: Int) -> [DBEntityType]
}
