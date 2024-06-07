//
//  ZUAlertProtocol.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2023/2/25.
//

import UIKit

public protocol ZUAlertProtocol {
    var contentViewController: UIViewController { get }
    var actions: [ZUAlertAction] { get }
}

public extension ZUAlertProtocol {
    var alertContainer: ZUAlertController? {
        return contentViewController.parent as? ZUAlertController
    }
}

public struct ZUAlert: ZUAlertProtocol {
    public let contentViewController: UIViewController
    public let actions: [ZUAlertAction]

    public init(contentViewController: UIViewController, actions: [ZUAlertAction] = []) {
        self.contentViewController = contentViewController
        self.actions = actions
    }

    public init(contentView: UIView, preferredContentSize: CGSize, actions: [ZUAlertAction]) {
        let contentViewController = ZUContentViewController(view: contentView)
        contentViewController.preferredContentSize = preferredContentSize
        self.init(contentViewController: contentViewController, actions: actions)
    }
}

