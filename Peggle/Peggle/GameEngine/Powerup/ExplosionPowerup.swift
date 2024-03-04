//
//  ExplosionPowerup.swift
//  Peggle
//
//  Created by proglab on 3/3/24.
//

import Foundation

class ExplosionPowerup: Powerup {
    static let explosionRadius = 100.0
    static let forceMagnitude = 50.0 * Constants.forceScale

    func activate(hitPeg: GamePeg, gameEngine: GameEngine) {
        gameEngine.removePeg(hitPeg)

        for peg in gameEngine.gamePegs
            where peg.position.distance(to: hitPeg.position) <= ExplosionPowerup.explosionRadius {
            gameEngine.removePeg(peg)
            if peg.pegType == .powerup && !peg.isHitByBall {
                activate(hitPeg: peg, gameEngine: gameEngine)
            }
        }

        for block in gameEngine.gameBlocks
            where block.position.distance(to: hitPeg.position) <= ExplosionPowerup.explosionRadius {
            gameEngine.removeBlock(block)
        }

        if let ball = gameEngine.ball, ball.position.distance(to: hitPeg.position) <= ExplosionPowerup.explosionRadius {
            let unitForceVector = (ball.position - hitPeg.position).normalize()
            ball.physicsBody.applyForce(unitForceVector * ExplosionPowerup.forceMagnitude)
        }
    }
}
