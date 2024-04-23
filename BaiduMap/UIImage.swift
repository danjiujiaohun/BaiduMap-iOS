//
//  UIImage.swift
//  blogProject
//
//  Created by 梁江斌 on 2023/8/12.
//

import Foundation
import UIKit

public extension UIImage {
    static func image(_ iconName: iconName) -> UIImage {
        UIImage(named: iconName.getName(), in: .Common, compatibleWith: nil)!
    }
}

/// 智能设备图片资源
public enum iconName: String, CaseIterable {
    /// 返回图标
    case back_icon
    /// 关闭图标
    case close_btn
    /// 个人中心_默认头像
    case avatar_default
    
    func getName() -> String {
        "image_" + rawValue
    }
}
