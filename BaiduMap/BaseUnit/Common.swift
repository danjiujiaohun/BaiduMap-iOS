//
//  Common.swift
//  blogProject
//
//  Created by 梁江斌 on 2023/8/12.
//

import Foundation
import UIKit

public struct Common {
    // 屏幕宽
    public static let screenWidth = UIScreen.main.bounds.width
    // 屏幕1/2宽
    public static let screenHalfWidth = UIScreen.main.bounds.width / 2
    // 屏幕高
    public static let screenHeight = UIScreen.main.bounds.height
    // 屏幕1/2高
    public  static let screenHalfHeight = UIScreen.main.bounds.height / 2
    // 状态栏高
    public static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    // 导航栏高 local
    public static let navigationBarHeight:CGFloat = 44
    // 顶部高 local
    public static let navigatorHeight:CGFloat = navigationBarHeight + statusBarHeight
    // 底部高 local
    public static let tabBarHeight = 49 + safeAreaBottom
    
    // safeArea
    // safeAreaBottom 34
    public static let safeAreaBottom = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    // safeAreaTop 44/iOS14变更为48
    public static let safeAreaTop = UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    
    // 等比例尺寸
    public static let widthScale = (Common.screenWidth / 375.0)
    public static let heightScale = (Common.screenHeight / 667.0)
    public static let lineHeight = 1 / UIScreen.main.scale

    // 刘海屏
    public static var isFullScreen: Bool {
        if let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w,
            unwrapedWindow.safeAreaInsets.bottom > 0 {
            return true
        }
        if let w = UIApplication.shared.windows.first,w.safeAreaInsets.bottom > 0 {
            return true
        }
        return false
    }
    
    // 小尺寸屏
    public static var isSmallScreen: Bool {
        return Common.screenWidth <= 320 ? true : false
    }
}
