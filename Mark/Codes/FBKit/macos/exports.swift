//
//  exports.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import Foundation
import UIKit




public typealias FBCallback = () -> Void
public typealias FBAnyBlock = @convention(block) (Any?) -> Void
public typealias FBIntBlock = @convention(block) (Int) -> Void
public typealias FBBoolBlock = @convention(block) (Bool) -> Void
public typealias FBStringBlock = @convention(block) (String) -> Void
public typealias FBRequestBlock = @convention(block) (String) -> Void
public typealias FBArrBlock = @convention(block) ([Int]) -> Void
public typealias FBFloatBlock = @convention(block) (Float) -> Void




public let k_window_width      = UIScreen.main.bounds.size.width
public let k_window_height     = UIScreen.main.bounds.size.height
public let is_iphone_x = UIApplication.shared.statusBarFrame.height > 20 ? true : false
public let k_nav_bar_height:CGFloat = is_iphone_x ? 88 : 64
public let k_status_bar_height:CGFloat = is_iphone_x ? 44 : 20
public let k_safe_tabbar_bottom:CGFloat = is_iphone_x ? 34 : 0

/// 按照屏幕宽度 最大为428进行缩放
public func fixScaleFor414(_ x: CGFloat) -> CGFloat {
    floor( min(k_window_width, 428) / 475 * x )
}


/// 完全按照屏幕宽度进行比例缩放
public func fixDevice(_ x: CGFloat) -> CGFloat {
    floor( k_window_width / 375 * x )
}

//// inlinable 可以让方法在执行的时候调用
public dynamic func currentViewController() -> UIViewController? {
    guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
        let window = UIApplication.shared.windows.last
        if let vc = window?.rootViewController {
            return firstViewController(vc)
        }
        return nil
    }
    return firstViewController(vc)
}


fileprivate func firstViewController(_ vc:UIViewController) -> UIViewController {
    if vc is UINavigationController {
        let navVC = vc as! UINavigationController
        return firstViewController(navVC.topViewController!)
    }else if vc is UITabBarController {
        let tabVC = vc as! UITabBarController
        return firstViewController(tabVC.viewControllers![tabVC.selectedIndex])
    }else if vc.presentedViewController != nil {
        return firstViewController(vc.presentedViewController!)
    }
    return vc
}

#if DEBUG

func printt(_ items: Any...,separator: String = " ", terminator: String = "\n") {
    print(Date().string(withFormat: "HH:mm:ss.SSS"),items)
}
#else

func printt(_ items: Any...,separator: String = " ", terminator: String = "\n") {
    
}
#endif
