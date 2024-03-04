//
//  CollisionInfo.swift
//  Peggle
//
//  Created by proglab on 18/2/24.
//

import Foundation

struct CollisionInfo {
    static let none = CollisionInfo(body1: nil, body2: nil, normal: .zero, penetration: .zero)

    let body1: PhysicsBody?
    let body2: PhysicsBody?
    let normal: CGVector
    let penetration: Double
}
