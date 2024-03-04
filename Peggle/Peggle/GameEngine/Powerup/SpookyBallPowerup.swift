//
//  SpookyBallPowerup.swift
//  Peggle
//
//  Created by proglab on 3/3/24.
//

import Foundation

class SpookyBallPowerup: Powerup {
    var ballIsSpooky = false

    func activate(hitPeg: GamePeg, gameEngine: GameEngine) {
        ballIsSpooky = true
    }

    func useIfConditionsMet(on ball: Ball, gameBounds: CGSize) {
        guard ballIsSpooky && isBallOutOfBounds(ball: ball, gameBounds: gameBounds) else {
            return
        }

        let newPosition = CGPoint(x: ball.position.x, y: Ball.radius)
        ball.setPosition(to: newPosition)

        ballIsSpooky = false
    }

    private func isBallOutOfBounds(ball: Ball, gameBounds: CGSize) -> Bool {
        ball.position.y > gameBounds.height
    }
}
