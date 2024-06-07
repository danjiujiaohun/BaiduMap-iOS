//
//  ZUAlertAction.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2023/2/25.
//

import UIKit

public class ZUAlertAction: NSObject {
    public enum Style {
        case normal, destructive, confirm
    }

    public enum Behaviour {
        case keep
        case dismissThen(() -> Void)

        public static var dismiss: Behaviour {
            return .dismissThen {}
        }
    }

    public let title: String
    public let icon: UIImage?
    public let style: Style
    public let handler: (ZUAlertAction) -> Behaviour

    public init(
        title: String,
        icon: UIImage? = nil,
        style: Style,
        handler: @escaping ((ZUAlertAction) -> Behaviour) = { _ in .dismiss }
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.handler = handler
    }

    func perform(in viewController: ZUAlertController) {
        let result = handler(self)
        switch result {
        case .keep:
            break
        case let .dismissThen(completion):
            viewController.dismiss(animated: true, completion: completion)
            
        }
    }
    
    
}

