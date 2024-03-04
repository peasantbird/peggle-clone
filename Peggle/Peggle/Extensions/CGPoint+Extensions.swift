//
//  CGPoint+Distance.swift
//  Peggle
//
//  Created by proglab on 1/2/24.
//

import CoreGraphics
import Foundation

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

    func distance(to point: CGPoint) -> Double {
        sqrt(pow((point.x - x), 2) + pow((point.y - y), 2))
    }

    func move(by vector: CGVector) -> CGPoint {
        CGPoint(x: x + vector.dx, y: y + vector.dy)
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
        CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }
}
