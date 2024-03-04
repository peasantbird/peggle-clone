//
//  Ball.swift
//  Peggle
//
//  Created by proglab on 18/2/24.
//

import Foundation

class Ball {
    static let radius = 15.0
    static var diameter: Double {
        radius * 2
    }
    static let mass = 0.05
    static let restitution = 0.8

    let physicsBody: PhysicsBody
    var position: CGPoint {
        physicsBody.center
    }

    init(position: CGPoint) {
        let shape = Circle(center: position, radius: Ball.radius)
        self.physicsBody = PhysicsBody(
            shape: shape,
            mass: Ball.mass,
            restitution: Ball.restitution,
            affectedByGravity: true,
            isDynamic: true
        )
    }

    func setPosition(to position: CGPoint) {
        physicsBody.setPosition(to: position)
    }
}
