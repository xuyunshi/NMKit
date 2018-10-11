//
//  UIColor+Extension.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation

public extension NMKit where Base: UIColor {
    func colorWithAlpha(_ a: CGFloat)-> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var alpha: CGFloat = 0
        base.getRed(&r, green: &g, blue: &b, alpha: &alpha)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIColor: NMKitCompatible {}
