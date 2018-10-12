//
//  NMTextField.swift
//  NMKit
//
//  Created by xuyunshi on 2018/10/11.
//

import Foundation

public class NMTextField: UITextField {
    
    /// 文字的左边距
    @IBInspectable var leftMargin: CGFloat = 0.0
    
    /// 本属性请在其他属性设置完之后再设置
    var placeHolderColor: UIColor? {
        didSet {
            guard let c = placeHolderColor else { return }
            guard let p = placeholder else { return }
            let attri = [NSAttributedStringKey.font: font!, NSAttributedStringKey.foregroundColor: c]
            attributedPlaceholder = NSAttributedString(string: p, attributes: attri)
        }
    }
    
    /// 左视图边距
    var leftViewMargin: CGFloat = 0
    
    init() {
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftMargin, dy: 0)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftMargin, dy: 0)
    }
    
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += leftViewMargin
        return rect
    }
}
