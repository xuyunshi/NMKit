//
//  UIView+Extension.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation
import SnapKit

let kShadowContainerTag = 405029644

extension UIView {
    @IBInspectable var XIBCornerradius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var BorderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor:layer.borderColor ?? UIColor.clear.cgColor)
        }
    }
    
    @IBInspectable var BorderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
}

extension UIView: NMKitCompatible {}

extension NMKit where Base: UIView {
    
    var shadowContainerView: UIView? {
        get {
            return base.superview?.viewWithTag(kShadowContainerTag)
        }
    }
    
    /// 设置阴影
    ///
    /// - Parameters:
    ///   - model: 阴影模型
    ///   - cornerRadius: 阴影和圆角。如果需要添加这个属性，请在视图被添加到父视图上再使用
    func setShadow(_ model: ShadowModel, cornerRadius: CGFloat = 0) {
        if cornerRadius == 0 {
            self.base.layer.shadowColor = model.color.cgColor
            self.base.layer.shadowRadius = model.radius
            self.base.layer.shadowOpacity = model.alpha
            self.base.layer.shadowOffset = model.offset
            self.base.layer.masksToBounds = false
        } else {
            self.base.layer.cornerRadius = cornerRadius
            if let superView = self.base.superview {
                let shadowView = UIView()
                shadowView.layer.shadowColor = model.color.cgColor
                shadowView.layer.shadowRadius = model.radius
                shadowView.layer.shadowOpacity = model.alpha
                shadowView.layer.shadowOffset = model.offset
                shadowView.layer.masksToBounds = false
                shadowView.tag = kShadowContainerTag
                superView.insertSubview(shadowView, belowSubview: self.base)
                shadowView.snp.makeConstraints { (make) in
                    make.edges.equalTo(self.base)
                }
                
                let shadowFakeContainer = UIView()
                shadowFakeContainer.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
                shadowFakeContainer.layer.cornerRadius = cornerRadius
                shadowView.addSubview(shadowFakeContainer)
                shadowFakeContainer.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
    
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        guard base.layer.mask == nil else { return }
        let maskPath = UIBezierPath(roundedRect: self.base.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.base.bounds
        maskLayer.path = maskPath.cgPath
        self.base.layer.mask = maskLayer
    }
}

struct ShadowModel {
    var offset: CGSize
    var radius: CGFloat
    var color: UIColor
    var alpha: Float
}
