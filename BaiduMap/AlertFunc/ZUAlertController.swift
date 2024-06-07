//
//  ZUAlertController.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2023/2/25.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

public class ZUAlertController: UIViewController {
    public var alert: ZUAlertProtocol {
        fatalError("Not implemented")
    }

    public var buttons: [UIButton] {
        fatalError("Not implemented")
    }
    
    public var contentViewController: UIViewController {
        return alert.contentViewController
    }
    
    deinit{
        print("ZUAlertController release")
    }

    public static func actionSheetViewController(
        alert: ZUAlertProtocol,
        isAutoClose:Bool = true,
        onClose: (() -> Void)? = nil
    ) -> ZUAlertController {
        return ZUActionSheetViewController(
            alert: alert,
            isAutoClose:isAutoClose,
            onClosed: onClose
        )
    }
    
}
