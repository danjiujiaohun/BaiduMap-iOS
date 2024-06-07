//
//  ZUContentViewController.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2023/2/25.
//

import UIKit

class ZUContentViewController: UIViewController {
    private let _view: UIView

    init(view: UIView) {
        _view = view
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = _view
//        view.backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var shouldAutorotate: Bool {
        return false
    }
}
