//
//  UIApplication+Extension.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation

extension NMKit where Base: UIApplication {
    func topViewController() -> UIViewController {
        return topVCWithRootVC((base.keyWindow?.rootViewController)!)
    }
    
    private func topVCWithRootVC(_ r: UIViewController) -> UIViewController {
        if let tab = r as? UITabBarController {
            return topVCWithRootVC(tab.selectedViewController!)
        } else if let navi = r as? UINavigationController {
            return topVCWithRootVC(navi.visibleViewController!)
        } else if let presented = r.presentedViewController {
            return topVCWithRootVC(presented)
        } else {
            return r
        }
    }
}

extension UIApplication: NMKitCompatible {}
