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
    /// 定位摁钮
    case location_btn
    /// 中心定位_泡泡
    case map_center_paopao
    /// 向右箭头
    case arrow_icon
    /// 交换箭头
    case exchange_icon
    
    func getName() -> String {
        "image_" + rawValue
    }
}
