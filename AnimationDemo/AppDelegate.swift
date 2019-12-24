//
//  AppDelegate.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/9.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: HomeViewController())
        window?.makeKeyAndVisible()
        configRealm()
        return true
    }

    fileprivate func configRealm() {
         let buildStr = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
         let buildNum = UInt64(buildStr) ?? 1
         let config = Realm.Configuration(schemaVersion: UInt64(buildNum), migrationBlock: { (migration, oldSchemaVersion) in })
         print("Realm Path:\n",Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "")
         Realm.Configuration.defaultConfiguration = config
     }
}

