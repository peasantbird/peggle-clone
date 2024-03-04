//
//  GameViewModel.swift
//  Peggle
//
//  Created by proglab on 20/2/24.
//

import Foundation
import QuartzCore

class GameViewModel: ObservableObject {
    let board: Board
    private(set) var boardSize = CGSize.zero
    private(set) var cannonAimPoint = CGPoint.zero
    var cannonPosition: CGPoint {
        let x = boardSize.width / 2
        let y = Constants.cannonYOffset
        return CGPoint(x: x, y: y)
    }
    var powerupSelectionPopupPosition: CGPoint {
        let x = boardSize.width / 2
        let y = boardSize.height / 2
        return CGPoint(x: x, y: y)
    }
    var showingPowerupSelection = true
    let gameEngine = GameEngine()
    var ball: Ball? {
        gameEngine.ball
    }
    var bucket: Bucket? {
        gameEngine.bucket
    }
    var gameBlocks: [GameBlock] {
        gameEngine.gameBlocks
    }
    var gamePegs: [GamePeg] {
        gameEngine.gamePegs
    }
    var ballIsCollected = false
    var ballsLeft: Int {
        gameEngine.ballsLeft
    }
    var gameIsWon: Bool {
        gameEngine.gameIsWon
    }
    var gameIsLost: Bool {
        gameEngine.gameIsLost
    }
    private var displayLink: CADisplayLink?
    private var lastUpdateTime: TimeInterval?

    init(board: Board) {
        self.board = board
        addPegs()
        addBlocks()
    }

    func setBoardSize(_ size: CGSize) {
        boardSize = size
        gameEngine.boardSize = size
    }

    /// Points the cannon vertically downwards from its position.
    func setDefaultCannonAimPoint() {
        let downwardsUnitVector = CGVector(dx: 0, dy: 1)
        cannonAimPoint = cannonPosition.move(by: downwardsUnitVector)
    }

    func setCannonAimPoint(_ point: CGPoint) {
        let x = point.x
        let y: Double
        if point.y > Constants.cannonYOffset {
            y = point.y
        } else {
            y = Constants.cannonYOffset
        }

        let aimPoint = CGPoint(x: x, y: y)

        // If the aim point is the same as the cannon position,
        // the direction of the ball launch is undetermined,
        // which will lead to problems! We set the aim point
        // back to the default aim point.
        guard aimPoint != cannonPosition else {
            setDefaultCannonAimPoint()
            return
        }

        cannonAimPoint = aimPoint
    }

    func addPegs() {
        for peg in board.pegs {
            gameEngine.addPeg(peg)
        }
    }

    func addBlocks() {
        for block in board.blocks {
            gameEngine.addBlock(block)
        }
    }

    func addBucket() {
        let startingPosition = CGPoint(x: Constants.bucketWidth / 2, y: boardSize.height - Constants.bucketYOffset)
        gameEngine.addBucket(at: startingPosition)
    }

    func addWalls() {
        let topLeftPoint = CGPoint(x: 0.0, y: 0.0)
        let topRightPoint = CGPoint(x: boardSize.width, y: 0.0)
        let bottomLeftPoint = CGPoint(x: 0.0, y: boardSize.height)
        let bottomRightPoint = CGPoint(x: boardSize.width, y: boardSize.height)

        gameEngine.addWall(from: topLeftPoint, to: topRightPoint)
        gameEngine.addWall(from: bottomLeftPoint, to: topLeftPoint)
        gameEngine.addWall(from: bottomRightPoint, to: topRightPoint)
    }

    func selectPowerup(_ powerupType: PowerupType) {
        let powerup = Utils.createPowerup(for: powerupType)
        gameEngine.powerup = powerup
    }

    func launchBall() {
        guard !showingPowerupSelection else {
            return
        }

        gameEngine.launchBall(from: cannonPosition, to: cannonAimPoint)
    }

    func checkBallIsOutOfScreen() -> Bool {
        guard let ball else {
            return false
        }

        return ball.position.y > boardSize.height
    }

    func checkBallIsCollected() {
        guard checkBallIsOutOfScreen() else {
            return
        }

        guard let ball, let bucket else {
            return
        }

        let ballX = ball.position.x
        let bucketMinX = bucket.center.x - Constants.bucketWidth / 2 + Constants.bucketXSlant
        let bucketMaxX = bucket.center.x + Constants.bucketWidth / 2 - Constants.bucketXSlant

        if bucketMinX < ballX && bucketMaxX > ballX {
            ballIsCollected = true
        }
    }

    func markHitPegsForRemoval() {
        for gamePeg in gamePegs where gamePeg.isHitByBall {
            gameEngine.markPegForRemoval(gamePeg)
        }
    }

    func removePegsLabeledForRemoval() {
        for gamePeg in gamePegs where gamePeg.toBeRemoved {
            gameEngine.removePeg(gamePeg)
        }
    }

    func resetBall() {
        gameEngine.resetBall()
    }

    func returnBallIfCollected() {
        if ballIsCollected {
            gameEngine.incrementBallsLeft()
        }
        ballIsCollected = false
    }

    func startGameLoop() {
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.add(to: .current, forMode: .common)
    }

    @objc func step(displayLink: CADisplayLink) {
        guard let lastUpdateTime else {
            self.lastUpdateTime = displayLink.timestamp
            return
        }

        let deltaTime = displayLink.timestamp - lastUpdateTime
        self.lastUpdateTime = displayLink.timestamp
        gameEngine.update(dt: deltaTime)

        if checkBallIsOutOfScreen() {
            checkBallIsCollected()
            markHitPegsForRemoval()
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.animationDuration) {
                self.removePegsLabeledForRemoval()
                self.returnBallIfCollected()
                self.resetBall()
            }
        }

        objectWillChange.send()

        if gameIsWon || gameIsLost {
            stopGameLoop()
        }
    }

    func stopGameLoop() {
        displayLink?.invalidate()
        displayLink = nil
        lastUpdateTime = nil
    }
}
