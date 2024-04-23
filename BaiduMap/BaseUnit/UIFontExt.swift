//
//  UIFontExt.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/4/23.
//

import Foundation
import UIKit

public enum ZUFontSize: CGFloat, CaseIterable {
    /// 80
    case h1_xxxl = 80
    /// 50
    case h1_xxl = 50
    /// 48
    case h1_xsl = 48
    /// 40
    case h1_xl = 40
    /// 34
    case h1_l = 34
    /// 32
    case h1_s = 32
    /// 28
    case h2_m = 28
    /// 24
    case h2_m2 = 24
    /// 22
    case h2_m4 = 22
    /// 20
    case h2_m3 = 20
    /// 18
    case h2_s = 18
    /// 16
    case text_m = 16
    /// 14
    case tips_m = 14
    /// 12
    case tips_s = 12
    /// 10
    case tips_xs = 10
    /// 8
    case tips_xxs = 8
}

public enum ZUFontWeight: String, CaseIterable {
    /// 细
    case thin = "Thin"
    /// 普通
    case regular = "Regular"
    /// 中黑
    case medium = "Medium"
    /// 纤细
    case light = "Light"
    /// 极细
    case ultralight = "Ultralight"
    /// 中粗
    case bold = "Semibold"
}

public extension UIFont {
    /// 默认苹方字体
    /// - Parameters:
    ///   - size: 真实字体大小
    static func font(of size: CGFloat, weight: ZUFontWeight = .regular) -> UIFont {
        let name = "PingFangSC-" + weight.rawValue
        let font = UIFont(name: name, size: size)
        return font ?? UIFont.systemFont(ofSize: ZUFontSize.text_m.rawValue, weight: .regular)
    }

    static func system(of size: ZUFontSize, weight: UIFont.Weight = .regular) -> UIFont {
        .systemFont(ofSize: size.rawValue, weight: weight)
    }
}
