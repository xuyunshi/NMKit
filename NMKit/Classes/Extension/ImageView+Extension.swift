//
//  ImageView+Extension.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation
import Kingfisher
import SKPhotoBrowser

public extension NMKit where Base: UIImageView {
    func setImage(_ url: String) {
        self.base.kf.setImage(with: URL(string: url))
    }
    
    func setScopeImages(_ urls: [String], index: Int) {
        base.isUserInteractionEnabled = true
        var button: UIButton?
        base.subviews.forEach {
            if let b = $0 as? UIButton {
                button = b
            }
        }
        if button == nil { button = UIButton() }
        guard let b = button else { return }
        if !(base.subviews.contains(b)) {
            base.addSubview(b)
            b.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            b.addTarget(self, action: #selector(UIImageView.onClickScopeButton), for: .touchUpInside)
            base.scopeImageURLs = urls
            base.scopeImageIndex = index
        }
    }
}

var ScopeImageIndexKey: Void?
var ScopeImageURLsKey: Void?

public extension UIImageView {
    
    var scopeImageIndex: Int {
        get {
            return objc_getAssociatedObject(self, &ScopeImageIndexKey) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &ScopeImageIndexKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var scopeImageURLs: [String]? {
        get {
            return objc_getAssociatedObject(self, &ScopeImageURLsKey) as? [String]
        }
        set {
            objc_setAssociatedObject(self, &ScopeImageURLsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc func onClickScopeButton() {
        if let urls = scopeImageURLs {
            let photos = urls.map { SKPhoto.photoWithImageURL($0) }
            let b = SKPhotoBrowser.init(photos: photos, initialPageIndex: scopeImageIndex)
            UIApplication.shared.nm.topViewController().present(b, animated: true, completion: nil)
        }
    }
}
