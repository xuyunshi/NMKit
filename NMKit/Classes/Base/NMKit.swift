//
//  NMKit.swift
//  OBD-CAR
//
//  Created by 许允是 on 2018/9/3.
//  Copyright © 2018 com.netmi. All rights reserved.
//  NMKit

import Foundation

public final class NMKit<Base> {
    public let base: Base
    public init(_ base: Base) { self.base = base }
}

public protocol NMKitCompatible {
    associatedtype Compatibletype
    var nm: Compatibletype { get }
}

public extension NMKitCompatible {
    public var nm: NMKit<Self> { return NMKit(self) }
}
