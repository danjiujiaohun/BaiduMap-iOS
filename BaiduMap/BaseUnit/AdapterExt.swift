//
//  AdapterExt.swift
//  blogProject
//
//  Created by 梁江斌 on 2023/8/12.
//

import Foundation
import UIKit

extension Int{
    /// 根据屏幕宽比例适配
    public func fit() -> CGFloat{
        return CGFloat(self) * Common.widthScale
    }
}

extension CGFloat{
    /// 根据屏幕宽比例适配
    public func fit() -> CGFloat{
        return self * Common.widthScale
    }
}
