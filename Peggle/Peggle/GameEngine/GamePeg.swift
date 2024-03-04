//
//  GamePeg.swift
//  Peggle
//
//  Created by proglab on 21/2/24.
//

import Foundation

class GamePeg: Identifiable {
    let pegType: PegType
    let radius: Double
    var diameter: Double {
        radius * 2
    }
    let physicsBody: PhysicsBody
    var position: CGPoint {
        physicsBody.center
    }
    var timesCollided: Int {
        physicsBody.timesCollided
    }
    var isHitByBall: Bool
    var toBeRemoved: Bool

    init(_ peg: Peg) {
        self.pegType = peg.pegType
        self.radius = peg.radius
        self.isHitByBall = false
        self.toBeRemoved = false

        let shape = Circle(center: peg.center, radius: self.radius)
        let mass = pegType == .stubborn ? 0.1 : Double.infinity
        let restitution = pegType == .stubborn ? 0.5 : 1.0
        let isDynamic = pegType == .stubborn ? true : false
        self.physicsBody = PhysicsBody(
            shape: shape,
            mass: mass,
            restitution: restitution,
            affectedByGravity: false,
            isDynamic: isDynamic
        )
    }
}
