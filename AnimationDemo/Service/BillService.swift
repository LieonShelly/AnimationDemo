//
//  BillService.swift
//  AnimationDemo
//
//  Created by lieon on 2019/12/23.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class BillService: StorageContext {
    typealias DBEntityType = Bill
    
    let realm = try! Realm(configuration: .defaultConfiguration)
    
    func save(object: Bill) throws {
        try? realm.write {
            realm.add(object, update: .all)
        }
    }
    
    func saveAll(objects: [Bill]) throws {
        try objects.forEach(save)
    }
    
    func update(object: Bill) throws {
        try? realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func delete(object: Bill) throws {
        try? realm.write {
            realm.delete(object)
        }
    }
    
    func deleteAll(_ model: Bill.Type) throws {
        try? realm.write {
            realm.deleteAll()
        }
    }
    
    func fetch(_ model: Bill.Type,
               predicate: NSPredicate? = nil,
               sorted: Sorted? = Sorted(key: "createDate"),
               page: Int = 0,
               num: Int = 20) -> [Bill] {
        var results: Results<Bill>?
        if let predicate = predicate {
            results = realm.objects(model).sorted(byKeyPath: sorted!.key, ascending: sorted!.ascending).filter(predicate)
            
        } else {
            results = realm.objects(model).sorted(byKeyPath: sorted!.key, ascending: sorted!.ascending)
        }
        if let results = results {
            var endIndex = (page + 1) * num - 1
            var startIndex = endIndex - num
            if startIndex < 0 {
                startIndex = 0
            }
            if endIndex > results.count {
                endIndex = results.count - 1
            }
            return results[startIndex ... endIndex].map { $0 }
        }
        return []
    }
}


class BillCategoryService: StorageContext {
    typealias DBEntityType = BillCategory
    let realm = try! Realm(configuration: .defaultConfiguration)
    func save(object: BillCategory) throws {
        try? realm.write {
            realm.add(object, update: .all)
        }
    }
    
    func saveAll(objects: [BillCategory]) throws {
        try objects.forEach(save)
    }
    
    func update(object: BillCategory) throws {
        try? realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func delete(object: BillCategory) throws {
        try? realm.write {
            realm.delete(object)
        }
    }
    
    func deleteAll(_ model: BillCategory.Type) throws {
        try? realm.write {
            realm.deleteAll()
        }
    }
    
    func fetch(_ model: BillCategory.Type, predicate: NSPredicate?, sorted: Sorted?, page: Int, num: Int) -> [BillCategory] {
        var results: Results<BillCategory>?
        if let predicate = predicate {
            results = realm.objects(model).sorted(byKeyPath: sorted!.key, ascending: sorted!.ascending).filter(predicate)
            
        } else {
            results = realm.objects(model).sorted(byKeyPath: sorted!.key, ascending: sorted!.ascending)
        }
        if let results = results {
            var endIndex = (page + 1) * num - 1
            var startIndex = endIndex - num
            if startIndex < 0 {
                startIndex = 0
            }
            if endIndex > results.count {
                endIndex = results.count - 1
            }
            return results[startIndex ... endIndex].map { $0 }
        }
        return []
    }
}
