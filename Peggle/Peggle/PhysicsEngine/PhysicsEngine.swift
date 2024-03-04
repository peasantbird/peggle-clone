//
//  PhysicsEngine.swift
//  Peggle
//
//  Created by proglab on 16/2/24.
//

import Foundation

class PhysicsEngine {
    var physicsBodies: [PhysicsBody] = []
    var gravity: CGVector

    init(gravity: CGVector = CGVector(dx: 0, dy: 9.8 * Constants.forceScale)) {
        self.gravity = gravity
    }

    func addPhysicsBody(_ physicsBody: PhysicsBody) {
        physicsBodies.append(physicsBody)
    }

    func removePhysicsBody(_ physicsBody: PhysicsBody) {
        if let index = physicsBodies.firstIndex(where: { $0 === physicsBody }) {
            physicsBodies.remove(at: index)
        }
    }

    func applyGravity() {
        for physicsBody in physicsBodies where physicsBody.affectedByGravity {
            physicsBody.applyForce(gravity * physicsBody.mass)
        }
    }

    func detectAndResolveCollisions() {
        for i in 0..<physicsBodies.count - 1 {
            for j in i + 1..<physicsBodies.count {
                let body1 = physicsBodies[i]
                let body2 = physicsBodies[j]
                let collisionInfo = CollisionDetector.detectBetween(body1, body2)
                CollisionResolver.resolve(collisionInfo: collisionInfo)
            }
        }
    }

    func update(dt deltaTime: TimeInterval) {
        applyGravity()
        detectAndResolveCollisions()

        for physicsBody in physicsBodies {
            physicsBody.update(dt: deltaTime)
        }
    }

    func detectBodiesColliding(with physicsBody: PhysicsBody) -> [PhysicsBody] {
        var collidingBodies: [PhysicsBody] = []

        for otherPhysicsBody in physicsBodies {
            if otherPhysicsBody === physicsBody {
                continue
            }

            let collisionInfo = CollisionDetector.detectBetween(physicsBody, otherPhysicsBody)
            if collisionInfo.body1 != nil && collisionInfo.body2 != nil {
                collidingBodies.append(otherPhysicsBody)
            }
        }

        return collidingBodies
    }
}
