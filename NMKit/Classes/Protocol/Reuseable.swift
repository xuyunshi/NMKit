//
//  Reuseable.swift
//  NMKit
//
//  Created by xuyunshi on 2018/9/27.
//

import Foundation

public extension NMKit where Base: UITableView {
    func registerClass<T: UITableViewCell>(_ reusable: T.Type) {
        self.base.register(reusable.self, forCellReuseIdentifier: reusable.identifier)
    }
    
    func registerNib<T: UITableViewCell>(_ reusable: T.Type){
        self.base.register(reusable.nib, forCellReuseIdentifier: reusable.identifier)
    }
    
    func dequeueCell<T: UITableViewCell>(_ reusable: T.Type) -> T {
        guard let cell = self.base.dequeueReusableCell(withIdentifier: reusable.identifier) as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(reusable.identifier) matching type \(reusable.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the cell beforehand"
            )
        }
        return cell
    }
}

public extension NMKit where Base: UICollectionView {
    enum SectionElementType: String {
        case header
        case footer
        
        var kindString: String {
            return self == .header ? UICollectionElementKindSectionHeader : UICollectionElementKindSectionFooter
        }
    }
    
    func registerClass<T: UICollectionViewCell>(_ reusable: T.Type) {
        self.base.register(reusable.self, forCellWithReuseIdentifier: reusable.identifier)
    }
    
    func registerNib<T: UICollectionViewCell>(_ reusable: T.Type){
        self.base.register(reusable.nib, forCellWithReuseIdentifier: reusable.identifier)
    }
    
    func dequeueCell<T: UICollectionViewCell>(_ reusable: T.Type, indexPath: IndexPath) -> T {
        guard let cell = self.base.dequeueReusableCell(withReuseIdentifier: reusable.identifier, for: indexPath) as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(reusable.identifier) matching type \(reusable.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the cell beforehand"
            )
        }
        return cell
    }
    
    func registerSupplementaryViewNib<T: UICollectionReusableView>(_ reusable: T.Type, type: SectionElementType) {
        self.base.register(reusable.nib, forSupplementaryViewOfKind: type.kindString, withReuseIdentifier: reusable.identifier)
    }
    
    func registerSupplementaryViewClass<T: UICollectionReusableView>(_ reusable: T.Type, type: SectionElementType) {
        self.base.register(reusable.self, forSupplementaryViewOfKind: type.kindString, withReuseIdentifier: reusable.identifier)
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(of type: SectionElementType, reusable: T.Type,for indexPath: IndexPath) -> T{
        guard let cell = self.base.dequeueReusableSupplementaryView(ofKind: type.kindString, withReuseIdentifier: reusable.identifier, for: indexPath) as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(reusable.identifier) matching type \(reusable.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the cell beforehand"
            )
        }
        return cell
    }
}

public protocol Reusable: class {
    static var identifier: String { get }
    static var nib: UINib { get }
}


public extension Reusable {
    static var identifier: String { return String(describing: self)}
    static var nib: UINib {
        let nib = UINib(nibName: String(describing: self), bundle: Bundle.main)
        return nib
    }
}

extension UITableViewCell: Reusable {}
extension UICollectionViewCell: Reusable {}
extension UICollectionReusableView: Reusable {}
