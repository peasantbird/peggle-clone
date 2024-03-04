//
//  Wall.swift
//  Peggle
//
//  Created by proglab on 21/2/24.
//

import Foundation

class Wall {
    static let mass = Double.infinity
    static let restitution = 1.0

    let physicsBody: PhysicsBody

    init(startPoint: CGPoint, endPoint: CGPoint) {
        let shape = Line(startPoint: startPoint, endPoint: endPoint)
        self.physicsBody = PhysicsBody(
            shape: shape,
            mass: Wall.mass,
            restitution: Wall.restitution,
            affectedByGravity: false,
            isDynamic: false
        )
    }
}
