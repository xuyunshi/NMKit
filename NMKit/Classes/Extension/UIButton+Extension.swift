//
//  UIButton+Extension.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation
import Kingfisher

var verticalImageTitleSpacingKey: Void?
let NMImageTitleSpacingNone:CGFloat = 9999.9999

public extension NMKit where Base: UIButton {
    // 调整水平间距（图片,文字)
    func horizontalCenterImageAndTitlte(with spacing: CGFloat) {
        self.base.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing, 0, 0)
        self.base.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -spacing)
    }
    
    // 调整水平间距（文字, 图片)
    func horizontalCenterTitleAndImage(with spacing: CGFloat) {
        guard let imageSize = base.imageView?.bounds.size else { return }
        guard let text = base.titleLabel?.text else { return }
        let nstext = NSString(string: text)
        let titleSize = nstext.boundingRect(with: base.bounds.size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:base.titleLabel!.font], context: nil).size
        let totalWidth = imageSize.width + titleSize.width + spacing
        base.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(totalWidth - imageSize.width)*2)
        base.titleEdgeInsets = UIEdgeInsetsMake(0, -(totalWidth - titleSize.width) * 2, 0, 0)
    }
    
    // 垂直居中图片文字
    func verticalCenterImageAndTitle(with spacing:CGFloat) {
        guard let imageSize = base.imageView?.bounds.size else { return }
        guard let text = base.titleLabel?.text else { return }
        let nstext = NSString(string: text)
        let titleSize = nstext.boundingRect(with: base.bounds.size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:base.titleLabel!.font], context: nil).size
        let totalHeight = imageSize.height + titleSize.height + spacing
        base.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0, 0, -titleSize.width)
        base.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(totalHeight - titleSize.height), 0)
    }
    
    func setWebImage(_ url: String, for state: UIControlState) {
        base.kf.setImage(with: URL(string: url), for: .normal)
    }
}
