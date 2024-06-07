//
//  UIButtonExt.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/6/7.
//

import Foundation
import UIKit

extension UIButton {
    /// 带标题的按钮
    public static func button(title: String?) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControl.State.normal)
        return button
    }
    
    /// 带标题、标题颜色的按钮
    public static func button(title: String?, titleColor: UIColor?) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControl.State.normal)
        button.setTitleColor(titleColor, for: UIControl.State.normal)
        return button
    }
    
    /// 带标题、标题颜色、标题字体大小的按钮
    public static func button(title: String?, titleColor: UIColor?, fontSize: CGFloat?) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControl.State.normal)
        button.setTitleColor(titleColor, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize!)
        return button
    }
    
    /// 带标题、标题颜色、标题字体大小、背景颜色的按钮
    public static func button(title: String?,
                              titleColor: UIColor?,
                              fontSize: CGFloat?,
                              backgroundColor: UIColor?) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControl.State.normal)
        button.setTitleColor(titleColor, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize!)
        button.backgroundColor = backgroundColor
        return button
    }
    
    /// 带点击效果的图片按钮
    public static func button(normalImage: UIImage?, highlightImage: UIImage?) -> UIButton {
        let button = UIButton()
        button.setImage(normalImage, for: UIControl.State.normal)
        button.setImage(highlightImage, for: UIControl.State.highlighted)
        return button
    }
    
    /// 带有选中效果的图片按钮
    public static func button(normalImage: UIImage?, selectedImage: UIImage?) -> UIButton {
        let button = UIButton()
        button.setImage(normalImage, for: UIControl.State.normal)
        button.setImage(selectedImage, for: UIControl.State.selected)
        return button
    }
    
    /// 带标题、标题颜色、标题字体大小并且有点击效果的图片按钮
    public static func button(title: String?,
                              titleColor: UIColor?,
                              fontSize: CGFloat?,
                              normalImage: UIImage?,
                              highlightImage: UIImage?) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControl.State.normal)
        button.setTitleColor(titleColor, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize!)
        button.setImage(normalImage, for: UIControl.State.normal)
        button.setImage(highlightImage, for: UIControl.State.highlighted)
        return button
    }
    
    /// 创建带标题的无点击效果，图片和标题有偏移的Button
    public static func button(title: String?,
                              titleColor: UIColor?,
                              fontSize: CGFloat?,
                              normalImage: UIImage?,
                              titleEdgeInsets: UIEdgeInsets?,
                              imageEdgeInsets: UIEdgeInsets?) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControl.State.normal)
        button.setTitleColor(titleColor, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize!)
        button.setImage(normalImage, for: UIControl.State.normal)
        button.titleEdgeInsets = titleEdgeInsets!
        button.imageEdgeInsets = imageEdgeInsets!
        return button
    }
    
    /// 创建带标题的有点击效果，图片和标题有偏移的Button
    public static func button(title: String?,
                              titleColor: UIColor?,
                              fontSize: CGFloat?,
                              normalImage: UIImage?,
                              highlightImage: UIImage?,
                              titleEdgeInsets: UIEdgeInsets?,
                              imageEdgeInsets: UIEdgeInsets?) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControl.State.normal)
        button.setTitleColor(titleColor, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize!)
        button.setImage(normalImage, for: UIControl.State.normal)
        button.setImage(highlightImage, for: UIControl.State.highlighted)
        button.titleEdgeInsets = titleEdgeInsets!
        button.imageEdgeInsets = imageEdgeInsets!
        return button
    }
    
    /// 创建带标题带选择效果，图片和标题有偏移的Button
    public static func button(title: String?,
                              titleColor: UIColor?,
                              fontSize: CGFloat?,
                              normalImage: UIImage?,
                              selectedImage: UIImage?,
                              titleEdgeInsets: UIEdgeInsets?,
                              imageEdgeInsets: UIEdgeInsets?) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControl.State.normal)
        button.setTitleColor(titleColor, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize!)
        button.setImage(normalImage, for: UIControl.State.normal)
        button.setImage(selectedImage, for: UIControl.State.selected)
        button.titleEdgeInsets = titleEdgeInsets!
        button.imageEdgeInsets = imageEdgeInsets!
        return button
    }
    
    /// 创建带有标题，有渐变颜色的Button
    public static func button(title: String?,
                              titleColor: UIColor?,
                              fontSize: CGFloat?,
                              frame: CGRect?,
                              fromColor: UIColor,
                              toColor: UIColor) -> UIButton {
        let button = UIButton()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame!
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        gradientLayer.locations = [0, 1]
        gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
        button.layer.addSublayer(gradientLayer);
        
        button.setTitle(title, for: UIControl.State.normal)
        button.setTitleColor(titleColor, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize!)
        
        return button
    }
    
    /// 带标题、标题颜色、标题字体大小、背景颜色的按钮（老方法）
    public static func button(_ title:String,bgColor:UIColor,titleColor:UIColor,font:UIFont) -> UIButton{
        let button = UIButton(frame: .zero)
        button.backgroundColor = bgColor
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = font
        return button
    }
}
