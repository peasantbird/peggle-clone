//
//  GameEngine.swift
//  Peggle
//
//  Created by proglab on 18/2/24.
//

import Foundation

class GameEngine {
    static let launchBallMagnitude = 25.0 * Constants.forceScale

    var ball: Ball?
    var bucket: Bucket?
    var gameBlocks: [GameBlock] = []
    var gamePegs: [GamePeg] = []
    var walls: [Wall] = []
    let physicsEngine = PhysicsEngine()
    var powerup: Powerup = ExplosionPowerup()

    var ballsLeft = 10
    var boardSize = CGSize.zero
    var compulsoryPegsLeft: Int {
        gamePegs.filter({ $0.pegType == .compulsory }).count
    }
    var gameIsWon: Bool {
        compulsoryPegsLeft == 0
    }
    var gameIsLost: Bool {
        ballsLeft == 0 && compulsoryPegsLeft > 0
    }

    func launchBall(from start: CGPoint, to end: CGPoint) {
        guard ball == nil && ballsLeft > 0 else {
            return
        }

        // Initialize ball
        let ball = Ball(position: start)
        self.ball = ball
        physicsEngine.addPhysicsBody(ball.physicsBody)
        ballsLeft -= 1

        // Apply force on ball
        let unitVectorFromStartToEnd = (end - start).normalize()
        let force = GameEngine.launchBallMagnitude * unitVectorFromStartToEnd
        ball.physicsBody.applyForce(force)
    }

    func addPeg(_ peg: Peg) {
        let gamePeg = GamePeg(peg)
        gamePegs.append(gamePeg)
        physicsEngine.addPhysicsBody(gamePeg.physicsBody)
    }

    func addBlock(_ block: Block) {
        let gameBlock = GameBlock(block)
        gameBlocks.append(gameBlock)
        physicsEngine.addPhysicsBody(gameBlock.physicsBody)
    }

    func addBucket(at center: CGPoint) {
        let bucket = Bucket(center: center)
        self.bucket = bucket
        for physicsBody in bucket.physicsBody {
            physicsEngine.addPhysicsBody(physicsBody)
        }
    }

    func addWall(from start: CGPoint, to end: CGPoint) {
        let wall = Wall(startPoint: start, endPoint: end)
        walls.append(wall)
        physicsEngine.addPhysicsBody(wall.physicsBody)
    }

    func markPegForRemoval(_ gamePeg: GamePeg) {
        guard gamePeg.pegType != .stubborn else {
            return
        }

        gamePeg.toBeRemoved = true
    }

    func removePeg(_ gamePeg: GamePeg) {
        if let index = gamePegs.firstIndex(where: { $0 === gamePeg }) {
            gamePegs.remove(at: index)
            physicsEngine.removePhysicsBody(gamePeg.physicsBody)
        }
    }

    func removeBlock(_ gameBlock: GameBlock) {
        if let index = gameBlocks.firstIndex(where: { $0 === gameBlock }) {
            gameBlocks.remove(at: index)
            physicsEngine.removePhysicsBody(gameBlock.physicsBody)
        }
    }

    func resetBall() {
        guard let ball else {
            return
        }

        self.ball = nil
        physicsEngine.removePhysicsBody(ball.physicsBody)
    }

    func incrementBallsLeft() {
        ballsLeft += 1
    }

    func markPegsHitByBallAndApplyPowerups() {
        let pegsHitByBall = findPegsHitByBall()

        for peg in pegsHitByBall where !peg.isHitByBall {
            peg.isHitByBall = true

            if peg.pegType == .powerup {
                powerup.activate(hitPeg: peg, gameEngine: self)
            }
        }
    }

    func findPegsHitByBall() -> [GamePeg] {
        guard let ball else {
            return []
        }

        var pegsHitByBall: [GamePeg] = []

        let physicsBodiesHitByBall = physicsEngine.detectBodiesColliding(with: ball.physicsBody)
        for physicsBody in physicsBodiesHitByBall {
            let pegHitByBall = gamePegs.first(where: { $0.physicsBody === physicsBody })
            if let pegHitByBall {
                pegsHitByBall.append(pegHitByBall)
            }
        }

        return pegsHitByBall
    }

    func reverseBucketDirectionOnBoundsCollision() {
        if isBucketCollidingWithBounds() {
            bucket?.reverseDirection()
        }
    }

    func isBucketCollidingWithBounds() -> Bool {
        guard let bucket else {
            return false
        }

        let minX = bucket.center.x - Constants.bucketWidth / 2
        let maxX = bucket.center.x + Constants.bucketWidth / 2

        return minX < 0 || maxX > boardSize.width
    }

    func useSpookyBallIfConditionsMet() {
        guard let spookyBallPowerup = powerup as? SpookyBallPowerup, let ball else {
            return
        }

        spookyBallPowerup.useIfConditionsMet(on: ball, gameBounds: boardSize)
    }

    func removeObjectsIfBallIsStuck() {
        for gamePeg in gamePegs where gamePeg.timesCollided >= Constants.collisionThreshold {
            removePeg(gamePeg)
        }
        for gameBlock in gameBlocks where gameBlock.timesCollided >= Constants.collisionThreshold {
            removeBlock(gameBlock)
        }
    }

    func update(dt deltaTime: TimeInterval) {
        if let bucket {
            reverseBucketDirectionOnBoundsCollision()
            bucket.move(dt: deltaTime)
        }
        markPegsHitByBallAndApplyPowerups()
        physicsEngine.update(dt: deltaTime)
        useSpookyBallIfConditionsMet()
        removeObjectsIfBallIsStuck()
    }
}
