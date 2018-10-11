//
//  NMPageExtension.swift
//  NMKit
//
//  Created by 许允是 on 2018/9/11.
//  Copyright © 2018 com.netmi. All rights reserved.
//

import Foundation

public protocol Pageable: class {
    
    associatedtype Element
    
    var maxCountPerPage: Int { get }
    
    var pageableDataList: [Element] { get set }
    
    var pageNumber: Int { get set }
    
    var pageableScrollView: UIScrollView { get }
    
    func handlePage(with list: [Element])
}

public extension Pageable {
    var maxCountPerPage:Int {
        get {
            return 10
        }
    }
}

public extension Pageable where Self: UIViewController {
    
    func handlePage(with list: [Element]) {
        
        pageableScrollView.mj_header.endRefreshing()
        
        if list.count < maxCountPerPage {
            pageableScrollView.mj_footer.endRefreshingWithNoMoreData()
        } else {
            pageableScrollView.mj_footer.endRefreshing()
        }
        
        if pageNumber == 0 {
            pageableDataList =  list
        } else {
            pageableDataList.append(contentsOf: list)
        }
        
        if let table =  pageableScrollView as? UITableView { table.reloadData() }
        if let collection = pageableScrollView as? UICollectionView { collection.reloadData() }
    }
}
