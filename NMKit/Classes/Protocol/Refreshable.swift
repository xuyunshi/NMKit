//
//  NMRefreshExtension.swift
//  NMKit
//
//  Created by 许允是 on 2018/9/7.
//  Copyright © 2018 com.netmi. All rights reserved.
//

import Foundation

@objc protocol Refreshable: class {
    func loadNewData()
    func loadMoreData()
}

extension NMKit where Base: UIScrollView {
    
    // TODO: 需要添加一个全局头部和尾部的功能
    // 以后再说吧
    
    /// 自动设置头尾.
    /// 如果要全局设置一个头尾部，请在项目中创建一个NMDefaultHeader或者NMDefaultFooter
    /// - Parameter delegate: 加载数据的代理
    func setupNormalHeaderFooter(delegate: Refreshable) {
        let header: MJRefreshHeader
        let footer: MJRefreshFooter
        // 这个全局功能暂时不可用
        if let headerType = NSClassFromString("NMDefaultHeader") as? MJRefreshHeader.Type {
            header = headerType.init()
            header.refreshingTarget = delegate
            header.refreshingAction = #selector(delegate.loadNewData)
        } else {
            header = MJRefreshNormalHeader(refreshingTarget: delegate, refreshingAction: #selector(delegate.loadNewData))
        }
        
        if let footerType = NSClassFromString("NMDefaultFooter") as? MJRefreshFooter.Type {
            footer = footerType.init()
            footer.refreshingTarget = delegate
            footer.refreshingAction = #selector(delegate.loadMoreData)
        } else {
            footer = MJRefreshAutoNormalFooter(refreshingTarget: delegate, refreshingAction: #selector(delegate.loadMoreData))
        }
        
        self.base.mj_header = header
        self.base.mj_footer = footer
    }
    
    var footer: MJRefreshFooter {
        get {
            return self.base.mj_footer
        }
        set {
            self.base.mj_footer = newValue
        }
    }
    
    var header: MJRefreshHeader {
        get {
            return self.base.mj_header
        }
        set {
            self.base.mj_header = newValue
        }
    }
}
