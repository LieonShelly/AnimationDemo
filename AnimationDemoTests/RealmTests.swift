//
//  RealmTests.swift
//  AnimationDemoTests
//
//  Created by lieon on 2019/12/23.
//  Copyright © 2019 lieon. All rights reserved.
//

import XCTest
import Realm
import RealmSwift
@testable import AnimationDemo

class RealmTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
    }
    
    override func setUp() {
        super.setUp()
        configRealm()
    }
    
    override class func tearDown() {
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRealmCURD() {
        let service = BillService()
        let newBill = Bill()
        newBill.amount = 100
        newBill.category = BillCategory.game.rawValue
        newBill.createDate = Date().timeIntervalSince1970
        newBill.date = Date().timeIntervalSince1970
        newBill.name = "zhilang"
        newBill.note = "zhilang_note"
        do {
            try service.save(object: newBill)
        } catch {
            XCTAssertThrowsError(error)
        }
        
    }
    
    fileprivate func configRealm() {
        let buildStr = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
        let buildNum = UInt64(buildStr) ?? 1
        let config = Realm.Configuration(schemaVersion: UInt64(buildNum), migrationBlock: { (migration, oldSchemaVersion) in })
        print("Realm Path:\n",Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "")
        Realm.Configuration.defaultConfiguration = config
    }
    
}
