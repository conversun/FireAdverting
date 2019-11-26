//
//  UIView+Nib.swift
//
//  Copyright 2018-2019 Twitter, Inc.
//  Licensed under the MoPub SDK License Agreement
//  http://www.mopub.com/legal/sdk-license-agreement/
//

import UIKit

extension UIView {
    func loadViewFromNib(nibName: String?) -> UIView? {
        guard let nibName = nibName else {
            return nil
        }
        let path = Bundle(for: type(of: self)).path(forResource: "MozartCore", ofType: "bundle") ?? ""
        let bundle = Bundle(path: path)
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    func sizeFitting(view: UIView) -> CGSize {
        var fittingSize: CGSize = .zero
        if #available(iOS 11, *) {
            fittingSize = CGSize(width: view.bounds.width - (view.safeAreaInsets.left + view.safeAreaInsets.right), height: 0)
        } else {
            fittingSize = CGSize(width: view.bounds.width, height: 0)
        }

        let size = systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return size
    }
}

extension UIApplication {
    static var rootController: UIViewController? {
        return shared.keyWindow?.rootViewController
    }
}

extension UIViewController {
    var rootVC: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }

    var visibleVC: UIViewController? {
        return topMost(of: rootVC)
    }

//    var visibleChildVC: UIViewController? {
//        let vc = topMost(of: rootVC)
//        if let child = vc?.children.first {
//            return child
//        }
//        return vc
//    }

    var visibleTabBarController: UITabBarController? {
        return topMost(of: rootVC)?.tabBarController
    }

    var visibleNavigationController: UINavigationController? {
        return topMost(of: rootVC)?.navigationController
    }

    private func topMost(of viewController: UIViewController?) -> UIViewController? {
        if let presentedViewController = viewController?.presentedViewController {
            return topMost(of: presentedViewController)
        }

        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return topMost(of: selectedViewController)
        }

        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return topMost(of: visibleViewController)
        }

        return viewController
    }
}

extension UIApplication {
    /// SwifterSwift: Application running environment.
    ///
    /// - debug: Application is running in debug mode.
    /// - testFlight: Application is installed from Test Flight.
    /// - appStore: Application is installed from the App Store.
    enum Environment {
        /// Application is running in debug mode.
        case debug
        /// Application is installed from Test Flight.
        case testFlight
        /// Application is installed from the App Store.
        case appStore
    }

    /// SwifterSwift: Current inferred app environment.
    var inferredEnvironment: Environment {
        #if DEBUG
            return .debug

        #elseif targetEnvironment(simulator)
            return .debug

        #else
            if Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil {
                return .testFlight
            }

            guard let appStoreReceiptUrl = Bundle.main.appStoreReceiptURL else {
                return .debug
            }

            if appStoreReceiptUrl.lastPathComponent.lowercased() == "sandboxreceipt" {
                return .testFlight
            }

            if appStoreReceiptUrl.path.lowercased().contains("simulator") {
                return .debug
            }

            return .appStore
        #endif
    }
}
