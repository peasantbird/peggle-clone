//
//  GameBlock.swift
//  Peggle
//
//  Created by proglab on 3/3/24.
//

import Foundation

class GameBlock: Identifiable {
    static let mass = Double.infinity
    static let resitution = 1.0

    let width: Double
    let height: Double
    let physicsBody: PhysicsBody
    var position: CGPoint {
        physicsBody.center
    }
    var timesCollided: Int {
        physicsBody.timesCollided
    }

    init(_ block: Block) {
        self.width = block.width
        self.height = block.height

        let shape = Rectangle(center: block.center, width: Constants.blockWidth, height: Constants.blockHeight)
        let mass = GameBlock.mass
        let restitution = GameBlock.resitution
        self.physicsBody = PhysicsBody(
            shape: shape,
            mass: mass,
            restitution: restitution,
            affectedByGravity: false,
            isDynamic: false
        )
    }
}
