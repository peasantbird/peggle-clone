//
//  Bucket.swift
//  Peggle
//
//  Created by proglab on 1/3/24.
//

import Foundation

class Bucket {
    static let mass = Double.infinity
    static let restitution = 1.0

    var center: CGPoint
    var velocity = CGVector(dx: 100, dy: 0)
    let physicsBody: [PhysicsBody]

    init(center: CGPoint) {
        self.center = center
        let centerX = center.x
        let centerY = center.y

        let topLeftPoint = CGPoint(x: centerX - Constants.bucketWidth / 2,
                                   y: centerY - Constants.bucketHeight / 2 + Constants.bucketOpeningMidPoint)
        let bottomLeftPoint = CGPoint(x: centerX - Constants.bucketWidth / 2 + Constants.bucketXSlant,
                                      y: centerY + Constants.bucketHeight / 2)
        let topRightPoint = CGPoint(x: centerX + Constants.bucketWidth / 2,
                                    y: centerY - Constants.bucketHeight / 2 + Constants.bucketOpeningMidPoint)
        let bottomRightPoint = CGPoint(x: centerX + Constants.bucketWidth / 2 - Constants.bucketXSlant,
                                       y: centerY + Constants.bucketHeight / 2)

        let leftLine = Line(startPoint: topLeftPoint, endPoint: bottomLeftPoint)
        let rightLine = Line(startPoint: topRightPoint, endPoint: bottomRightPoint)

        let leftLinePhysicsBody = PhysicsBody(
            shape: leftLine,
            mass: Bucket.mass,
            restitution: Bucket.restitution,
            affectedByGravity: false,
            isDynamic: false,
            velocity: velocity
        )
        let rightLinePhysicsBody = PhysicsBody(
            shape: rightLine,
            mass: Bucket.mass,
            restitution: Bucket.restitution,
            affectedByGravity: false,
            isDynamic: false,
            velocity: velocity
        )

        self.physicsBody = [leftLinePhysicsBody, rightLinePhysicsBody]
    }

    func move(dt deltaTime: TimeInterval) {
        let deltaPosition = velocity * deltaTime
        center = center.move(by: deltaPosition)
    }

    func reverseDirection() {
        let newVelocity = velocity.negate()
        self.velocity = newVelocity
        for physicsBody in physicsBody {
            physicsBody.setVelocity(newVelocity)
        }
    }
}
