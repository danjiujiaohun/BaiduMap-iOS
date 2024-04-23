//
//  BaseViewController.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2024/4/23.
//

import UIKit

///
/// LeftBarButtonItemType, RightBarButtonItemType 枚举类型，作为FDBaseViewControlelr基础类 属否显示 ButtonItem 判断根据
///

enum ZUButtonItemType {
    case left
    case right
}

public enum LeftBarButtonItemType {
    /// 无任何设置
    case none
    /// 隐藏
    case hide
    /// 自定义
    case custom(imageName: String?, bundle: Bundle?, titleName: String?, size: CGSize?, color:UIColor?=nil)
    /// 图片
    case image(_ image: UIImage, size: CGSize?)
}

public enum RightBarButtonItemType {
    /// 无任何设置
    case none
    /// 自定义
    case custom(imageName: String?, bundle: Bundle?, titleName: String?,color:UIColor? = nil, size: CGSize?)
    /// 图片
    case image(_ image: UIImage, size: CGSize?)
}

///
/// BaseViewController 提供一系列相关视图控制器一些通用方法和属性，可以在派生类中重写或者直接调用。
/// 1.设置BarButtonItem
///
open class BaseViewController: UIViewController {
    
    //MARK: - Propertys
    
    /// 左 BarButtonItemType
    private var leftBarButtonItemType: LeftBarButtonItemType = .none {
        didSet {
            switch leftBarButtonItemType {
            case .none:
                navigationItem.leftBarButtonItem = nil
                break
            case .hide:
                navigationItem.hidesBackButton = true
                break
            case .custom(let imageName, let bundle, let titleName, let size,let color):
                setNavBarBtnItem(imageStr: imageName, bundle: bundle, title: titleName, size: size, color: color, type: .left)
                break
            case .image(let image, let size):
                setNavBarBtnItem(image: image, size: size, type: .left)
                break
            }
        }
    }
    
    /// 右 BarButtonItemType
    private var rightBarButtonItemType: RightBarButtonItemType = .none {
        didSet {
            switch rightBarButtonItemType {
            case .none:
                navigationItem.rightBarButtonItem = nil
                break
            case .custom(let imageName, let bundle, let titleName,let color, let size):
                setNavBarBtnItem(imageStr: imageName, bundle: bundle, title: titleName,size: size, color: color, type: .right)
                break
            case .image(let image, let size):
                setNavBarBtnItem(image: image, size: size, type: .right)
                break
            }
        }
    }
    
    //MARK: - Life Cycle
    private var orientation: UIInterfaceOrientationMask = .portrait
    public init(orientation: UIInterfaceOrientationMask) {
        self.orientation = orientation
        super.init(nibName: nil, bundle: nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        triggerNavBarisTranslucentEvent()
        triggerHairlineImageViewUnderEvent()
        triggerNavBarisHiddenEvent()
        triggerNavTitleColor()
    }
    
    private func setWindow() {
        if let window = UIApplication.shared.keyWindow {
            window.backgroundColor = UIColor.white
        }
    }
    
    ///
    /// 每次进入BaseViewController都会设置相关默认配置
    ///
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 默认是 不透明 ，如果透明需要 子类 改变其属性
        triggerNavBarisTranslucentEvent()
        triggerHairlineImageViewUnderEvent()
        triggerNavBarisHiddenEvent()
        triggerNavTitleColor()
    }
    
    //MARK: - Override Method
    
    ///
    /// BaseViewController 设置 BarbuttonItem 方法
    ///
    public func setBarButtonItem( _ left: LeftBarButtonItemType? = nil, _ right: RightBarButtonItemType? = nil) {
        if let l = left { leftBarButtonItemType = l }
        if let r = right { rightBarButtonItemType = r }
    }
    
    /// NavBar is transparent setting
    /// 可以继承父类 isNavBarisTranslucent 属性 来控制 NavBar
    public var isNavBarisTranslucent: Bool = false {
        didSet {
            if isNavBarisTranslucent {
                navigationController?.navigationBar.isTranslucent = true
                navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationController?.navigationBar.shadowImage = UIImage()
                navigationController?.view.backgroundColor = .clear
                navigationController?.navigationBar.backgroundColor = UIColor.clear
            } else {
                navigationController?.navigationBar.isTranslucent = false
            }
        }
    }
    
    /// NavBar is hidden setting
    /// 可以继承父类 isNavBarisHidden 属性 来控制 NavBar
    public var isNavBarisHidden: Bool = false {
        didSet {
            if isNavBarisHidden {
                navigationController?.setNavigationBarHidden(true, animated: false)
            } else {
                navigationController?.setNavigationBarHidden(false, animated: false)
            }
        }
    }
    
    /// NavBar is hidden setting
    /// 可以继承父类 isNavBarisHidden 属性 来控制 NavBar
    public var navTitleColor: UIColor = UIColor.color(.color_24292B) {
        didSet {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: navTitleColor]
        }
    }
    
    
    /// NavBar hairlineImageViewUnder show ?
    /// 可以继承父类 hairlineImageViewUnder 属性 来控制 Navibar下面横线
    public var hairlineImageViewUnder: Bool = true {
        didSet {
            if hairlineImageViewUnder {
                
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
                
            } else {
                
                // Sets Bar's Background Image (Color) //
                //                navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: .white), for: .default)
                
                // Sets Bar's Shadow Image (Color) //
                navigationController?.navigationBar.shadowImage = UIImage.colorConvertImage(color: .lightGray)
                
            }
        }
    }
    
    
    
    /// BarbuttonItem left 点击回调
    open func leftItemAction() {
        print("left action")
    }
    
    /// BarbuttonItem right 点击回调
    open func rightItemAction() {
        print("right action")
    }
    
    /// emptyView button 点击回调
    open func emptyViewDidClickButton() {
        print("emptyView button")
    }
    
    ///
    /// Trigger Event
    ///
    private func triggerNavBarisTranslucentEvent() {
        let result = isNavBarisTranslucent
        isNavBarisTranslucent = result
    }
    
    func triggerNavBarisHiddenEvent() {
        let result = isNavBarisHidden
        isNavBarisHidden = result
    }
    
    private func triggerNavTitleColor() {
        let result = navTitleColor
        navTitleColor = result
    }
    
    private func triggerHairlineImageViewUnderEvent() {
        let result = hairlineImageViewUnder
        hairlineImageViewUnder = result
    }
}

//MARK: - Extension
extension BaseViewController {
    
    // 设置 BarButtonItem
    fileprivate func setNavBarBtnItem(image: UIImage? = nil, imageStr: String? = nil, bundle: Bundle? = nil, title: String? = nil, size: CGSize? = nil, color:UIColor? = nil,type: ZUButtonItemType) {
        let btnSize = size ?? CGSize(width: 24, height: 24)
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(origin: .zero, size: btnSize)
        if let i = image {
            button.setImage(i, for: UIControl.State.normal)
            button.setImage(i, for: UIControl.State.highlighted)
        } else if let img = imageStr, let bd = bundle {
            let i = UIImage(named: img, in: bd, compatibleWith: nil)
            button.setImage(i, for: UIControl.State.normal)
            button.setImage(i, for: UIControl.State.highlighted)
        }
        if let t = title {
            if let c = color {
                button.setTitle(t, for: .normal)
                button.setTitle(t, for: .highlighted)
                button.setTitleColor(c, for: .normal)
                button.setTitleColor(c, for: .highlighted)
                button.titleLabel?.font = .system(of: .tips_m)
            }else{
                button.setTitle(t, for: .normal)
                button.setTitle(t, for: .highlighted)
                button.setTitleColor(.color(.color_24292B), for: .normal)
                button.setTitleColor(.color(.color_24292B), for: .highlighted)
                button.titleLabel?.font = .system(of: .tips_m)
            }
        }
        
        setNavBarButtonItem(button:button, type, btnSize)
    }

    fileprivate func setNavBarButtonItem(button: UIButton,
                                      _ type: ZUButtonItemType,
                                      _ size: CGSize = CGSize(width: 24, height: 24))  {
        switch type {
        case .left:
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
            button.addAction(forControlEvents: UIControl.Event.touchUpInside) { [weak self] in
                self?.leftItemAction()
            }
            let buttonItem = UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem = buttonItem
            break
        case .right:
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
            button.addAction(forControlEvents: UIControl.Event.touchUpInside) { [weak self] in
                self?.rightItemAction()
            }
            let buttonItem = UIBarButtonItem(customView: button)
            self.navigationItem.rightBarButtonItem = buttonItem
            break
        }
    }
}

///
/// Control Extension
///
extension UIControl {
    func addAction(forControlEvents events: UIControl.Event, withCallBack callBack: @escaping () -> Void) {
        let wrapper = ClosureWrapper.init(callBack: callBack)
        
        addTarget(wrapper, action: #selector(wrapper.invoke), for: events)
        objc_setAssociatedObject(self, &associatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

/*
 Block of UIControl
 */
open class ClosureWrapper: NSObject {
    
    let closureCallBack: () -> Void
    init(callBack: @escaping () -> Void) {
        closureCallBack = callBack
    }
    
    @objc open func invoke() {
        closureCallBack()
    }
    
}

var associatedClosure: UInt8 = 0

///
/// ImagheSetColor
///
extension UIImage {
    class func colorConvertImage(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}


//MARK: - UINavigationControllerDelegate

extension BaseViewController: UINavigationControllerDelegate {
    
    ///
    /// 禁止横屏
    ///
    
    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return (navigationController.topViewController?.supportedInterfaceOrientations)!
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return orientation
    }
}
