//
//  CollisionResolver.swift
//  Peggle
//
//  Created by proglab on 18/2/24.
//

import Foundation

class CollisionResolver {
    static func resolve(collisionInfo: CollisionInfo) {
        guard let body1 = collisionInfo.body1, let body2 = collisionInfo.body2 else {
            return
        }

        let relativeVelocity = body2.velocity - body1.velocity
        let scalarProjectionOnNormal = CGVector.dotProduct(relativeVelocity, collisionInfo.normal)

        // If the scalar projection is positive, the relative velocity
        // has the same direction with respect to the collision normal.
        // The objects will separate and no collision resolution is needed.
        guard scalarProjectionOnNormal < 0 else {
            return
        }

        // Calculate impulse
        let restitution = min(body1.restitution, body2.restitution)
        let impulseScalar = -(1 + restitution) * scalarProjectionOnNormal / (1 / body1.mass + 1 / body2.mass)
        let impulse = impulseScalar * collisionInfo.normal

        // Apply impulse
        if body1.isDynamic {
            body1.velocity -= 1 / body1.mass * impulse
        }
        if body2.isDynamic {
            body2.velocity += 1 / body2.mass * impulse
        }
    }
}
