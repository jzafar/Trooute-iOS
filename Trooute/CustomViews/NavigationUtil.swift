//
//  NavigationUtil.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-04.
//

import SwiftUI
struct NavigationUtil {
    static func popToRootView(animated: Bool = true) {
        // Get the root view controller from the key window
        if let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?
            .rootViewController {
            
            // Dismiss any presented view controllers first
            dismissPresentedViewControllers(from: rootViewController) {
                // After dismissing, find the navigation controller and pop to the root
                findNavigationController(viewController: rootViewController)?.popToRootViewController(animated: animated)
            }
        }
    }
    
    private static func dismissPresentedViewControllers(from viewController: UIViewController, completion: @escaping () -> Void) {
        if let presentedVC = viewController.presentedViewController {
            // Dismiss the presented view controller
            presentedVC.dismiss(animated: true) {
                // Recursively check if there's another presented view controller
                dismissPresentedViewControllers(from: viewController, completion: completion)
            }
        } else {
            // No more presented view controllers, execute the completion
            completion()
        }
    }
    
    private static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        if let tabBarController = viewController as? UITabBarController {
            return findNavigationController(viewController: tabBarController.selectedViewController)
        }
        
        for childViewController in viewController.children {
            if let navigationController = findNavigationController(viewController: childViewController) {
                return navigationController
            }
        }
        
        return nil
    }
}

