//
//  UIColor.swift
//  blogProject
//
//  Created by 梁江斌 on 2023/8/12.
//

import Foundation
import UIKit

extension Bundle {
    static let Common = Bundle.main.bundle("Common")
}

public extension UIColor {
    static func color(_ name: ColorName) -> UIColor {
        let colorName: String = {
            return name.rawValue
        }()
        
        return UIColor(named: colorName, in: .Common, compatibleWith: nil) ?? UIColor.white
    }
}

public enum ColorName:String,CaseIterable {
    /// 0xFFFFFF
    case color_FFFFFF
    
    /// 0x000000
    case color_000000
    
    /// 0x24292B
    case color_24292B
    
    /// 0x9DA2A5
    case color_9DA2A5
    
    /// 0xFF453A 警告红色
    case color_FF453A
}
