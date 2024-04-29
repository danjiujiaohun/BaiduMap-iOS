//
//  AppDelegate.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/4/23.
//

import UIKit
import SnapKit
import BaiduMapAPI_Map
import RTRootNavigationController

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        
        let rootVC = RootViewController()
        let nav = RTRootNavigationController(rootViewController: rootVC)
        self.window?.rootViewController = nav
        
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

