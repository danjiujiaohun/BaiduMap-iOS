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
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        // 要使用百度地图，请先启动BMKMapManager
        let mapManager = BMKMapManager()
        // 启动引擎并设置AK并设置delegate
        if !(mapManager.start("EAFiA03ZVrX8NysNoUOM0eHtUYyePxrk", generalDelegate: self)) {
            NSLog("启动引擎失败")
        }
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        
        let rootVC = RootViewController()
        let nav = RTRootNavigationController(rootViewController: rootVC)
        self.window?.rootViewController = nav
        
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

