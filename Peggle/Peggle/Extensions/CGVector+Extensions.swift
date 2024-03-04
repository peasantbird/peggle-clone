//
//  CGVector+Extensions.swift
//  Peggle
//
//  Created by proglab on 16/2/24.
//

import Foundation

extension CGVector {

    static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    static func += (lhs: inout CGVector, rhs: CGVector) {
        lhs = lhs + rhs
    }

    static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    static func -= (lhs: inout CGVector, rhs: CGVector) {
        lhs = lhs - rhs
    }

    static func * (lhs: CGVector, rhs: CGFloat) -> CGVector {
        CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }

    static func * (lhs: CGFloat, rhs: CGVector) -> CGVector {
        CGVector(dx: rhs.dx * lhs, dy: rhs.dy * lhs)
    }

    static func / (lhs: CGVector, rhs: CGFloat) -> CGVector {
        guard rhs != 0 else {
            fatalError("Division by zero is not allowed.")
        }

        return CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
    }

    static func dotProduct(_ lhs: CGVector, _ rhs: CGVector) -> CGFloat {
        lhs.dx * rhs.dx + lhs.dy * rhs.dy
    }

    func length() -> CGFloat {
        sqrt(pow(dx, 2) + pow(dy, 2))
    }

    func normalize() -> CGVector {
        self / length()
    }

    func negate() -> CGVector {
        CGVector(dx: -self.dx, dy: -self.dy)
    }
}
