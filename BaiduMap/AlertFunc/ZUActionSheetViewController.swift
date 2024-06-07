//
//  ZUActionSheetViewController.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2023/2/25.
//

import UIKit

class ZUActionSheetViewController: ZUAlertController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet private weak var contentContainer: UIView!
    @IBOutlet private weak var contentHeightConstraint: NSLayoutConstraint!
    
    private var isAutoClose = true
        
    private let _alert: ZUAlertProtocol
    
    override var alert: ZUAlertProtocol {
        self._alert
    }
    let onClosed: (() -> Void)?
    
    init(
        alert: ZUAlertProtocol,
        isAutoClose:Bool,
        onClosed: (() -> Void)?
    ) {
        self._alert = alert
        self.isAutoClose = isAutoClose
        self.onClosed = onClosed
        super.init(nibName: "ZUActionSheetViewController", bundle: .uikit)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.modalPresentationCapturesStatusBarAppearance = true
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        let contentViewController = self.contentViewController
        
        let contentView: UIView = contentViewController.view
        contentView.clipsToBounds = true
        contentViewController.willMove(toParent: self)
        self.addChild(contentViewController)
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.contentContainer.addSubview(contentView)
        contentViewController.didMove(toParent: self)
        contentView.leadingAnchor.constraint(equalTo: self.contentContainer.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.contentContainer.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.contentContainer.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.contentContainer.bottomAnchor).isActive = true
        
        self.updatePreferredContentSize()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        guard container === self.contentViewController else {
            return
        }
        self.updatePreferredContentSize()
    }
    
    
    private func updatePreferredContentSize() {
        let size = self.contentViewController.preferredContentSize
        self.contentHeightConstraint.constant = size.height
        
        self.preferredContentSize = size
    }
    
    @IBAction private func cancelButtonTapped() {
        self.dismiss(animated: true) {
            guard let closure = self.onClosed else {
                return
            }
            closure()
        }
    }
    
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = ZUActionSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            isContainerAffectedByKeyboard: true
        )
        controller.onDimmingViewTapped = { [weak self] _ in
            guard let self = self,self.isAutoClose else {
                return
            }
            self.cancelButtonTapped()
        }
        return controller
    }
}
