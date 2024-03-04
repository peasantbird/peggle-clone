//
//  PeggleObject.swift
//  Peggle
//
//  Created by proglab on 3/3/24.
//

import Foundation

protocol PeggleObject: OverlapCheckable, OverlapVisitor {
    var minX: CGFloat { get }
    var maxX: CGFloat { get }
    var minY: CGFloat { get }
    var maxY: CGFloat { get }

    mutating func moveCenter(to newCenter: CGPoint)
}
