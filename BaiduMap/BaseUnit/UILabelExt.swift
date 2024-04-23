//
//  UILabelExt.swift
//  blogProject
//
//  Created by 梁江斌 on 2023/8/12.
//

import UIKit

extension UILabel {
    
    /** 带单行文本的标签 */
    class func label(text: String) -> UILabel {
        let label = UILabel.init()
        label.text = text
        return label
    }
    
    /** 带多行文本的标签 */
    class func label(text: String, numberOfLines: Int) -> UILabel {
        let label = UILabel.init()
        label.text = text
        label.numberOfLines = numberOfLines
        return label
    }
    
    /** 带单行文本、文本颜色的标签 */
    class func label(text: String, textColor: UIColor) -> UILabel {
        let label = UILabel.init()
        label.text = text
        label.textColor = textColor
        return label
    }
    
    /** 带多行文本、文本颜色的标签 */
    class func label(text: String, textColor: UIColor, numberOfLines: Int) -> UILabel {
        let label = UILabel.init()
        label.text = text
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        return label
    }
    
    /** 带文本、文本颜色、文本字体大小的标签 */
    class func label(_ text: String, textColor: UIColor, font: UIFont) -> UILabel {
        let label = UILabel.init()
        label.text = text
        label.textColor = textColor
        label.font = font
        return label
    }
    
}

