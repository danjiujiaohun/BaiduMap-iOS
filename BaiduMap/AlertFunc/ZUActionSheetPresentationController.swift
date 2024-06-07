//
//  ZUActionSheetPresentationController.swift
//  BaiduMap
//
//  Created by 梁江斌 on 2023/2/25.
//

import UIKit

class ZUActionSheetPresentationController: UIPresentationController {
    
    private let dimmingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isOpaque = false
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        view.alpha = 0.0
        return view
    }()
    
    var onDimmingViewTapped: (ZUActionSheetPresentationController) -> Void = { _ in }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, isContainerAffectedByKeyboard: Bool) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    convenience override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController, isContainerAffectedByKeyboard: false)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        guard let presentedView = self.presentedView, !self.presentedViewController.isBeingPresented else {
            return
        }
        presentedView.frame = self.frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView,
              let transitionCoordinator = self.presentingViewController.transitionCoordinator else {
            return
        }
        
        containerView.layoutMargins = .zero
        
        containerView.addSubview(self.dimmingView)
        self.dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        self.dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        self.dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        self.dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        self.dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPresented)))
        
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
        
        self.dimmingView.alpha = 0.0
        transitionCoordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        }, completion: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    @objc private func dismissPresented() {
        self.onDimmingViewTapped(self)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = self.presentingViewController.transitionCoordinator else {
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        }, completion: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        guard let containerView = self.containerView,
              let presentedView = self.presentedView, container === self.presentedViewController else {
            return
        }
        if presentedView.superview != nil {
            UIView.animate(withDuration: 0.25) {
                presentedView.frame = self.frameOfPresentedViewInContainerView
                containerView.setNeedsLayout()
                containerView.layoutIfNeeded()
            }
        } else {
            containerView.setNeedsLayout()
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = self.containerView else {
            return .zero
        }
        
        let size = self.presentedViewController.preferredContentSize
        let margin = containerView.layoutMargins
        let bounds = containerView.bounds
        let gap: CGFloat = 30
        
        var temp = CGRect.zero
        temp.size.height = Swift.max(0, Swift.min(size.height + margin.bottom, bounds.height - margin.top - gap))
        temp.origin.y = bounds.height - temp.height
        temp.size.width = bounds.width
        
        return temp
    }
}
