//
//  UILabel+Convenience.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation

public extension UILabel {
    convenience init(fontType: UIFont.NMFontType, size: CGFloat, color: UIColor, alignMent: NSTextAlignment = NSTextAlignment.left, text: String = "") {
        self.init()
        self.font = UIFont(type: fontType, size: size)
        self.textAlignment = alignMent
        self.text = text
        self.textColor = color
    }
}
