//
//  UIColor+Convenience.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation

extension UIColor {
    convenience init(_ hex: UInt32, alpha: CGFloat = 1.0) {
        let r = (CGFloat((hex & 0xFF0000) >> 16)) / 255.0
        let g = (CGFloat((hex & 0xFF00) >> 8)) / 255.0
        let b = (CGFloat((hex & 0xFF))) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue:UInt32 = 0
        scanner.scanHexInt32(&rgbValue)
        
        let r = (CGFloat((rgbValue & 0xFF0000) >> 16)) / 255.0
        let g = (CGFloat((rgbValue & 0xFF00) >> 8)) / 255.0
        let b = (CGFloat((rgbValue & 0xFF))) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
